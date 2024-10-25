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
    
    func savePomodoro(focusTime: Int, breakTime: Int, date: Date, tag: String)async throws -> CKRecord {
        
        let zoneID = CKRecordZone.ID(zoneName: "PomoInsightsZone")
        let record = CKRecord(recordType: TimerRecord.recordType, recordID: CKRecord.ID(zoneID: zoneID))
        
        record[TimerRecord.focusTimeKey] = focusTime as CKRecordValue
        record[TimerRecord.breakTimeKey] = breakTime as CKRecordValue
        record[TimerRecord.dateKey] = date as CKRecordValue
        record[TimerRecord.tagKey] = tag as CKRecordValue
        
        try await ensureZoneExists(zoneID: zoneID)
        
        return try await withCheckedThrowingContinuation { continuation in
            privateDatabase.save(record) { savedRecord, error in
                if let error = error {
                    print("Erro ao salvar record: \(error)")
                    continuation.resume(throwing: error)
                } else if let savedRecord = savedRecord {
                    print("Record salvo com sucesso.")
                    continuation.resume(returning: savedRecord)
                }
            }
        }
    }
    
    func ensureZoneExists(zoneID: CKRecordZone.ID) async throws {
        do {
            _ = try await privateDatabase.fetch(withRecordZoneID: zoneID){(fetchedZone, error) in}
            print("Zona já existe.")
        } catch let error as CKError where error.code == .zoneNotFound {
            // Se a zona não for encontrada, cria uma nova zona
            let customZone = CKRecordZone(zoneID: zoneID)
            try await privateDatabase.save(customZone)
            print("Zona criada com sucesso.")
        } catch {
            throw error // Lança outros erros se houver
        }
    }
}

struct TimerRecord {
    static let recordType = "pomoInsights"
    static let focusTimeKey = "focusotalTime"
    static let breakTimeKey = "breakTime"
    static let dateKey = "date"
    static let tagKey = "tag"
}

