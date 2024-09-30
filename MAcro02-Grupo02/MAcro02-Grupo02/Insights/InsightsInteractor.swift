//
//  InsightsInteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 25/09/24.
//

import Foundation

/*
 o que o interector vai fazer?
 funcoes do insights:
 mostrar informacoes
 */


protocol InsightsInteractorProtocol: AnyObject {
//    
//    //crud
//    func fetchInsightsData(completion: @escaping (Result<Bool, Error>) -> Void)
//    func removeInsightsData(insight: FocusDataModel,completion: @escaping (Result<Bool, Error>) -> Void)
//    func addInsightsData(insight: FocusDataModel, completion: @escaping (Result<Bool, Error>) -> Void)
//    func updateInsightsData(insight: FocusDataModel, completion: @escaping (Result<Bool, Error>) -> Void)
//    
//    //insights
//    func genereteInsightsPomoPerDay(completion: @escaping (InsightsDataModel) -> Void)
//    func genereteInsightsPomoPerWeek(completion: @escaping (InsightsDataModel) -> Void)
//    func genereteInsightsPerTag(completion: @escaping (InsightsDataModel) -> Void)
//    func genereteInsightsStrickerPerWeek(completion: @escaping (InsightsDataModel) -> Void)
//    func genereteInsightsStrickerTotal(completion: @escaping (InsightsDataModel) -> InsightsDataModel)
}

class InsightsInteractor : InsightsInteractorProtocol {
    private var presenter: InsightsPresenterProtocol?
    private var dataManager: InsightsData = InsightsData()

    init(presenter: InsightsPresenterProtocol) {
        self.presenter = presenter
    }
    
    
    func fetchInsightsData(type: InsightsType) {
        var insights: [InsightsDataModel] = []
        
        dataManager.queryTestData { result in
            
            result.forEach { id, data in
                switch data {
                case .success(let focusData):
                    break
//                    let insightsDataModel = InsightsDataModel(title: focusData., value: focusData.focusTimeInMinutes)
//                    insights.append(insightsDataModel)
                case .failure:
                    break
                }
                
            }
            
            if !insights.isEmpty {
//                self.presenter?.presentInsights(insights: insights)
            }
            
        }
    }
    
    func PomoPerDay() -> InsightsDataModel {
        
    }
    
    
}

enum FocusCategory: String, Codable {
    case work
    case rest
    case study
}


struct FocusDataModel: Identifiable {
    var id = UUID()
    var focusTimeInMinutes: Int
    var breakTimeinMinutes: Int
    var category: FocusCategory
    
}

enum InsightsType: String, Codable {
    case PomoPerDay
    case PomoPerWeek
    case InsightsPerTag
    case StrickerPerWeek
    case StrickerTotal
}

struct InsightsDataModel: Identifiable{
    var id = UUID()
    var title: String
    var value: Int
    
}
