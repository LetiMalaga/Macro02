////
////  PomodoroData.swift
////  MAcro02-Grupo02
////
////  Created by Luiz Felipe on 02/10/24.
////

import Foundation
import CloudKit
import CoreData
import UIKit
import Reachability


class PomodoroData {
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let userDefaultsStd = UserDefaults.standard
    
    private let cachedDataKey = "cachedData"
    private let reachability = try! Reachability()
    private var isSyncInProgress = false
    
    init() {
        setupReachability()
    }
    
        //MARK: verify connection disponibility
    private func setupReachability() {
        reachability.whenReachable = { [weak self] reachability in
            print("Conexão com a Internet disponível.")
            self?.syncDataDisponibility()
        }
        
        reachability.whenUnreachable = { _ in
            print("Sem conexão com a Internet.")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Não foi possível iniciar o monitoramento de rede: \(error.localizedDescription)")
        }
    }
    
    deinit {
        reachability.stopNotifier()
    }
    
    func syncDataDisponibility() {
        guard !isSyncInProgress else { return }
        isSyncInProgress = true
        
        // Carrega os dados do cache local
        let cachedData = loadCachedData()
        
        for data in cachedData {
            
            Task {
                try await savePomodoro(data) { [weak self] sucesso in
                    switch sucesso {
                    case .failure:
                        print("Não foi possível salvar o dado no CloudKit.")
                    default:
                        self?.removerDadoDoCache(data)
                        self?.isSyncInProgress = false
                    }
                }
            }
            
        }
    }
    
    // Salvar o dado no cache local (UserDefaults neste exemplo)
    func cacheDataLocally(_ data: FocusDataModel) {
        var cachedData = loadCachedData()
        cachedData.append(data)
        if let encodedData = try? JSONEncoder().encode(cachedData) {
            UserDefaults.standard.set(encodedData, forKey: cachedDataKey)
        }
    }
    
    // Carregar dados salvos localmente
    func loadCachedData() -> [FocusDataModel] {
        guard let data = UserDefaults.standard.data(forKey: cachedDataKey),
              let decodedData = try? JSONDecoder().decode([FocusDataModel].self, from: data) else {
            return []
        }
        return decodedData
    }
    
    func removerDadoDoCache(_ data: FocusDataModel) {
        var cachedData = loadCachedData()
        if let index = cachedData.firstIndex(where: { $0.id == data.id }) {
            cachedData.remove(at: index)
        }
        if let encodedData = try? JSONEncoder().encode(cachedData) {
            UserDefaults.standard.set(encodedData, forKey: cachedDataKey)
        }
    }
    
    //MARK: save pomodoro data
    func savePomodoro(_ data: FocusDataModel, completion: @escaping (Result<CKRecord, Error>) -> Void)async throws -> CKRecord {
        
        let zoneID = CKRecordZone.ID(zoneName: "PomoInsightsZone")
        let record = CKRecord(recordType: TimerRecord.recordType, recordID: CKRecord.ID(zoneID: zoneID))
        
        record[TimerRecord.focusTimeKey] = data.focusTimeInMinutes as CKRecordValue
        record[TimerRecord.breakTimeKey] = data.breakTimeinMinutes as CKRecordValue
        record[TimerRecord.longBreakTimeKey] = data.longBreakTimeInMinutes as CKRecordValue
        record[TimerRecord.dateKey] = data.date as CKRecordValue
        record[TimerRecord.tagKey] = data.category as CKRecordValue
        
        ensureZoneExists(zoneID: zoneID)
        
        return try await withCheckedThrowingContinuation { continuation in
            privateDatabase.save(record) { savedRecord, error in
                if let error = error as? CKError{
                    if error.code == .networkUnavailable || error.code == .networkFailure {
                        print("Ainda sem conexão, dados permanecem no cache.")
                        self.cacheDataLocally(data)
                    }
                    else {
                        print("Erro ao salvar no CloudKit: \(error.localizedDescription)")
                    }
                    continuation.resume(throwing: error)
                } else if let savedRecord = savedRecord {
                    //                    print("Record salvo com sucesso.")
                    completion( .success(savedRecord))
                    continuation.resume(returning: savedRecord)
                }
            }
        }
    }
    
    func ensureZoneExists(zoneID: CKRecordZone.ID) {
        privateDatabase.fetchAllRecordZones{ zones, error in
            if let zones{
                if ((zones.contains(where: {$0.zoneID == zoneID}))){
                    print("Zone already exists")
                }else{
                    let newZone = CKRecordZone(zoneID: zoneID)
                    self.privateDatabase.save(newZone){ _, error in
                        if let error{
                            print("Error saving new zone: \(error)")
                        }
                    }
                    
                }
            }
        }
    }
    
    func fetchActivities(_ type:ActivitiesType, tag:String) -> Activity? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        let contexts = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        request.predicate = NSPredicate(format: "tag == %@ AND type == %@", tag, type.rawValue)
        
        do {
            let activities = try contexts.fetch(request)
            return activities.randomElement()
            
        } catch {
            print("Failed to fetch activities: \(error)")
            return nil
        }
    }
    
}

struct TimerRecord {
    static let recordType = "pomoInsights"
    static let focusTimeKey = "focusotalTime"
    static let breakTimeKey = "breakTime"
    static let longBreakTimeKey = "longBreakTime"
    static let dateKey = "date"
    static let tagKey = "tag"
}
