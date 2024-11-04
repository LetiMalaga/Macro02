//
//  InsightsData.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 26/09/24.
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
                            print("success fetching records with data")
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

