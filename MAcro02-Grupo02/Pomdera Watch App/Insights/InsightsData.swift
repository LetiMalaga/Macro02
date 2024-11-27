//
//  InsightsData.swift
//  Pomdera Watch App
//
//  Created by Luiz Felipe on 25/11/24.
//

import Foundation
import CloudKit

protocol InsightsDataProtocol {
    func queryTestData(predicate: NSPredicate) async throws ->[CKRecord]
}

class InsightsData:InsightsDataProtocol{
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let zone = CKRecordZone(zoneName: "PomoInsightsZone")
    var records:[CKRecord] = []
    
    func queryTestData(predicate: NSPredicate) async throws -> [CKRecord]{
        
        let query = CKQuery(recordType: TimerRecord.recordType, predicate: predicate)
        return try await withCheckedThrowingContinuation { continuation in
            privateDatabase.fetch(withQuery: query, inZoneWith: zone.zoneID) { result in
                switch result {
                case .success(let records):
                    records.matchResults.forEach { record, result in
                        switch result {
                        case .success (let data):
                            self.records.append(data)
                        case .failure:
                            print("failure fetching records")
                            break
                        }
                    }
                    continuation.resume(returning: self.records)
                case .failure(let error):
                    print("error fetching records")
                    
                    continuation.resume(throwing: error)
                }
            }
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