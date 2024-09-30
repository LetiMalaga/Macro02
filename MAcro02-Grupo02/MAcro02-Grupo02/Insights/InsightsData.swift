//
//  InsightsData.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 26/09/24.
//

import Foundation
import CloudKit

class InsightsData {
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let zone = CKRecordZone(zoneName: "InsightsZone")
    var records = [CKRecord]()
    
    func saveZone() {
        privateDatabase.save(zone) { zone, error in
            if let error = error{
                print ("Error saving zone: \(error)")
            } else {
                print ("Zone saved successfully")
            }
        }
    }
    
    //salvando poucos elementos
    func saveTestData() {
        let record = CKRecord(recordType: "Insights", recordID: CKRecord.ID(zoneID: zone.zoneID))
        //record["test"] = "test"
        let value = "teste" as CKRecordValue
        record.setObject(value, forKey: "test")
        privateDatabase.save(record) { record, error in
            if let error = error{
                print ("Error saving record: \(error)")
            } else {
                print ("Record saved successfully")
            }
        }
    }
    
    //funcao para adicionar varias coisas no icloud
    func saveManyTestData() {
        let record = CKRecord(recordType: "Insights", recordID: CKRecord.ID(zoneID: zone.zoneID))
        //record["test"] = "test"
        let value = "teste" as CKRecordValue
        record.setObject(value, forKey: "test")
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        let config = CKOperation.Configuration()
        
        //tempo maximo de espera para requisicao no cloudkit
        config.timeoutIntervalForRequest = 10
        //tempo maximo para envio para o cloudkit
        config.timeoutIntervalForResource = 10
        
        operation.configuration = config
        
        operation.modifyRecordsResultBlock = {error in
//            
//            if let error = error{
//                print ("Error saving record: \(error)")
//            } else {
//                print ("Record saved successfully")
//            
//            }
        }
        privateDatabase.add(operation)
        
    }
    
    //funcao de query
    func queryTestData(closure: @escaping ([(CKRecord.ID, Result<CKRecord, any Error>)])-> Void){
        
        let query = CKQuery(recordType: "Insights", predicate: NSPredicate(value: true))
        privateDatabase.fetch(withQuery: query, inZoneWith: zone.zoneID) { result in
            switch result {
            case .success(let records):
                closure(records.matchResults)
            case .failure(let error):
                print("Error fetching records: \(error)")
            }
        }
        
    }
        
        //funcao para deletar atividades
        func deleteTestData(at indexpath: IndexPath) {
            let record = records[indexpath.row]
            privateDatabase.delete(withRecordID: record.recordID) { record, error in
                
            }
        }
    }

