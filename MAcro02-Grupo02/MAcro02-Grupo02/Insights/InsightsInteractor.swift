//
//  InsightsInteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 25/09/24.
//

import Foundation

protocol InsightsInteractorProtocol: AnyObject {
    func fetchInsightsData(completion: @escaping ([FocusDataModel], [BreakDataModel]) -> Void)
}

class InsightsInteractor: InsightsInteractorProtocol {
    
    func fetchInsightsData(completion: @escaping ([FocusDataModel], [BreakDataModel]) -> Void) {
        
    }
    
}
enum FocusCategory: String, Codable {
    case work
    case rest
    case study
}

enum BreakCategory: String, Codable {
    case work
    case rest
    case study
}


struct FocusDataModel {
    var timeInMinutes: Int
    var date: Date
    var category: FocusCategory
}

struct BreakDataModel {
    var timeInMinutes: Int
    var date: Date
    var category: FocusCategory
}
