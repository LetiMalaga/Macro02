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
    let zone = CKRecordZone(zoneName: "PomoInsightsZone")
    var records = [CKRecord]()
    
    func savePomodoro(focusTime: Int, breakTime: Int, date: Date, tag: String) {
        let record = CKRecord(recordType: TimerRecord.recordType, recordID: CKRecord.ID(zoneID: zone.zoneID))
        
        record[TimerRecord.focusTimeKey] = focusTime as CKRecordValue
        record[TimerRecord.breakTimeKey] = breakTime as CKRecordValue
        record[TimerRecord.dateKey] = date as CKRecordValue
        record[TimerRecord.tagKey] = tag as CKRecordValue
        
        privateDatabase.save(record) { record, error in
            if let error = error{
                print ("Error saving record: \(error)")
            } else {
                print ("Record saved successfully")
            }
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

