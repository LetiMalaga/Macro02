////
////  PomodoroData.swift
////  MAcro02-Grupo02
////
////  Created by Luiz Felipe on 02/10/24.
////

import Foundation
import CloudKit


class PomodoroData {
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let userDefaultsStd = UserDefaults.standard
    let udNewTagDataKey = "NewTagData"
    
    func savePomodoro(focusTime: Int, breakTime: Int, date: Date, tag: String, completion: @escaping (Result<CKRecord, Error>) -> Void)async throws -> CKRecord {
        
        let zoneID = CKRecordZone.ID(zoneName: "PomoInsightsZone")
        let record = CKRecord(recordType: TimerRecord.recordType, recordID: CKRecord.ID(zoneID: zoneID))
        
        record[TimerRecord.focusTimeKey] = focusTime as CKRecordValue
        record[TimerRecord.breakTimeKey] = breakTime as CKRecordValue
        record[TimerRecord.dateKey] = date as CKRecordValue
        record[TimerRecord.tagKey] = tag as CKRecordValue
        
        ensureZoneExists(zoneID: zoneID)
        
        return try await withCheckedThrowingContinuation { continuation in
            privateDatabase.save(record) { savedRecord, error in
                if let error = error {
                    print("Erro ao salvar record: \(error)")
                    completion(.failure(error))
                    continuation.resume(throwing: error)
                } else if let savedRecord = savedRecord {
                    print("Record salvo com sucesso.")
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
    
//    // MARK: User Defaults New Tag CRUD
//    func readTagsArray() {
//        guard userDefaultsStd.object(forKey: udNewTagDataKey) != nil else { return }
//    }
//    
//    func updateTagsArray(array: [String]) {
//        userDefaultsStd.set(array, forKey: udNewTagDataKey)
//    }
}

struct TimerRecord {
    static let recordType = "pomoInsights"
    static let focusTimeKey = "focusotalTime"
    static let breakTimeKey = "breakTime"
    static let dateKey = "date"
    static let tagKey = "tag"
}
