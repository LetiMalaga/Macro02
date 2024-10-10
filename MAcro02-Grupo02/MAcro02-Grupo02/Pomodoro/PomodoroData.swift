//
//  PomodoroData.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 02/10/24.
//

import Foundation
import CloudKit


class PomodoroData {
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let zone = CKRecordZone(zoneName: "InsightsZone")
    var records = [CKRecord]()
    
    func savePomodoro(time: Int) {
    }
}
