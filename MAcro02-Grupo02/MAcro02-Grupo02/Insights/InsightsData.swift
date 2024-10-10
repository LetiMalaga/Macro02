//
//  InsightsData.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 26/09/24.
//

import Foundation
import CloudKit

protocol InsightsDataProtocol {
    func queryTestData(predicate: NSPredicate, closure: @escaping ([(CKRecord.ID, Result<CKRecord, any Error>)])-> Void)
}

class InsightsData:InsightsDataProtocol{
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let zone = CKRecordZone(zoneName: "PomoInsightsZone")
    var records = [CKRecord]()

    func queryTestData(predicate: NSPredicate, closure: @escaping ([(CKRecord.ID, Result<CKRecord, any Error>)])-> Void){
        
        let query = CKQuery(recordType: TimerRecord.recordType, predicate: predicate)
        privateDatabase.fetch(withQuery: query, inZoneWith: zone.zoneID) { result in
            switch result {
            case .success(let records):
                closure(records.matchResults)
            case .failure(let error):
                print("Error fetching records: \(error)")
            }
        }
        
    }
}

