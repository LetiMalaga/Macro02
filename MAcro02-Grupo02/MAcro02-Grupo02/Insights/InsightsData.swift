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
    
    func fetchEarliestDateWithData(completion: @escaping (Date?) -> Void) {
        let predicate = NSPredicate(value: true)  // Retorna todos os registros
        let query = CKQuery(recordType: TimerRecord.recordType, predicate: predicate)
        
        // Ordena os resultados pela data em ordem crescente
        query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        // Configura a operação de consulta para obter apenas o primeiro resultado
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1
        
        var earliestDate: Date?
        
        // Define o bloqueio de resultado do registro
        queryOperation.recordMatchedBlock = { (id, result ) in
            switch result {
            case .success(let record):
                earliestDate = record["date"] as? Date
            case.failure(let error):
                print("Erro ao buscar a data mais antiga: \(error.localizedDescription)")
            }
            
        }
        queryOperation.queryResultBlock = { result in
            switch result {
            case .success(let records):
                completion(earliestDate)
            case.failure(let error):
                print("Erro ao buscar a data mais antiga: \(error.localizedDescription)")
                completion(nil)
            }
        }
        privateDatabase.add(queryOperation)
    }
}

