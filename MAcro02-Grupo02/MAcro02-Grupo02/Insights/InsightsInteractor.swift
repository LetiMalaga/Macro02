//
//  InsightsInteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 25/09/24.
//

import Foundation

protocol InsightsInteractorProtocol: AnyObject {
    
    func fetchInsightsData(predicate: NSPredicate, completion: @escaping ([FocusDataModel]) -> Void)
    func getInsights(predicate: NSPredicate) -> InsightsDataModel
    
    func insightsPerDay() 
    func insightsPerMonth()
    func insightsPerWeek()
    func getLastSunday() -> Date?
}

class InsightsInteractor : InsightsInteractorProtocol {
    
    private var presenter: InsightsPresenterProtocol?
    private var dataManager: InsightsData = InsightsData()
    
    init(presenter: InsightsPresenterProtocol) {
        self.presenter = presenter
    }
    
    func fetchInsightsData(predicate: NSPredicate, completion: @escaping ([FocusDataModel]) -> Void) {
        var focusData: [FocusDataModel] = []
        
        dataManager.queryTestData(predicate: predicate) { result in
            result.forEach { id, data in
                switch data {
                case .success(let focusResult): break

                case .failure:
                    break
                }
                
            }
            completion(focusData)
        }
    }
    
    func getInsights(predicate: NSPredicate) -> InsightsDataModel{
        var data: InsightsDataModel?
        self.fetchInsightsData(predicate: predicate) { result in
            var timeBreakInMinutes: Int = 0
            var timeFocusedInMinutes: Int = 0
            
            result.forEach { response in
                // Verifica se a categoria já existe no array de dicionários
                if let tempoAtual = data?.timeFocusedInMinutes[response.category] {
                    // Se a categoria já existe, soma o tempo
                    data?.timeFocusedInMinutes[response.category] = tempoAtual + response.focusTimeInMinutes
                } else {
                    // Se a categoria não existe, adiciona uma nova entrada
                    data?.timeFocusedInMinutes[response.category] = response.focusTimeInMinutes
                }
                timeBreakInMinutes += response.breakTimeinMinutes
                timeFocusedInMinutes += response.focusTimeInMinutes
                
            }
            
            data?.timeFocusedInMinutes.forEach({ tag in
                data!.timeFocusedInMinutes[tag.key] = data?.timeFocusedInMinutes[tag.key]
            })
            data?.value = result.count
            data?.timeBreakInMinutes = timeBreakInMinutes
            data?.timeTotalInMinutes = timeFocusedInMinutes + timeBreakInMinutes
            
        }
        return data!
    }
    func apliedInsights(insights: InsightsDataModel){
        presenter?.presentTagInsights(insights: insights)
        presenter?.presentFocusedInsights(insights: insights)
        presenter?.presentSessionInsights(insights: insights)
        presenter?.presenteBreakdownInsights(insights: insights)
        presenter?.presenteTotalTimeInsights(insights: insights)
    }
    func insightsPerDay() {
        let predicate = NSPredicate(format: "data == %@ ",Date() as CVarArg)
        apliedInsights(insights: getInsights(predicate: predicate))
    }
    
    func insightsPerWeek() {
        guard let lastSunday = getLastSunday() else {
            print("Erro ao calcular o último domingo")
            return
        }
        
        let today = Date()
        let predicate = NSPredicate(format: "data >= %@ AND data <= %@", lastSunday as CVarArg, today as CVarArg)
        
        apliedInsights(insights: getInsights(predicate: predicate))
    }
    
    func insightsPerMonth(){
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        guard let firstDayOfMonth = calendar.date(from: components) else {return }
        let predicate = NSPredicate(format: "creationDate >= %@ AND creationDate <= %@", argumentArray: [firstDayOfMonth, currentDate])

        apliedInsights(insights: getInsights(predicate: predicate))
    }
    
    
    // Função para calcular a data do último domingo
    func getLastSunday() -> Date? {
        let calendar = Calendar.current
        let today = Date()
        
        // Pegar o dia da semana de hoje (1 = Domingo, 7 = Sábado)
        let weekday = calendar.component(.weekday, from: today)
        
        // Calcular a diferença de dias entre hoje e o último domingo
        let daysToLastSunday = (weekday == 1) ? 0 : weekday - 1
        return calendar.date(byAdding: .day, value: -daysToLastSunday, to: today)
    }
}



struct FocusDataModel: Identifiable {
    var id = UUID()
    var focusTimeInMinutes: Int
    var breakTimeinMinutes: Int
    var longBreakTimeinMinutes: Int
    var category: Tags
    var date: Date
    
}

enum Tags: String, Codable {
    case focus
    case study
    case work
    case relax
    case sleep
}

struct InsightsDataModel: Identifiable{
    var id = UUID()
    var title: String
    
    var timeFocusedInMinutes: [Tags:Int]
    var timeTotalInMinutes: Int
    var timeBreakInMinutes: Int
    var value: Int?
    
}
