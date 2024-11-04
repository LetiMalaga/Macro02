//
//  InsightsInteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 25/09/24.
//

import Foundation


protocol InsightsInteractorProtocol: AnyObject {
    var insights: InsightsDataModel? { get }
    var presenter: InsightsPresenterProtocol? { get }
    //    var dataManager: InsightsDataProtocol? { get }
    
    func fetchInsightsData(predicate: NSPredicate, completion: @escaping ([FocusDataModel]) -> Void) async
    func getInsights(predicate: NSPredicate, completion: @escaping(InsightsDataModel) -> Void)
    
    func insightsPerDay()
    func insightsPerMonth()
    func insightsPerWeek()
    func getLastSunday() -> Date?
}


class InsightsInteractor : InsightsInteractorProtocol {
    
    var presenter: InsightsPresenterProtocol?
    var insights: InsightsDataModel?

    func fetchInsightsData(predicate: NSPredicate, completion: @escaping ([FocusDataModel]) -> Void) async{
        let dataManager = InsightsData()
        var focusData: [FocusDataModel] = []
        Task {
            do{
                let focusResult = try await dataManager.queryTestData(predicate: predicate)
                
                focusResult.forEach({ result in
                    if let tagString = result[TimerRecord.tagKey] as? String,
                       let tag = Tags(rawValue: tagString) {
                        let focus = FocusDataModel(focusTimeInMinutes: result[TimerRecord.focusTimeKey] as? Int ?? 0, breakTimeinMinutes: result[TimerRecord.breakTimeKey] as? Int ?? 0, category: tag, date: result[TimerRecord.dateKey] as? Date ?? Date())
                        focusData.append(focus)
                        
                    }
                })
                completion(focusData)
            }
            catch{
                print("error \(error) in fetching data")
            }
        }
        
    }
    
    func getInsights(predicate: NSPredicate, completion: @escaping (InsightsDataModel) -> Void) {
        var data: InsightsDataModel = InsightsDataModel(timeFocusedInMinutes: [:], timeTotalInMinutes: 0, timeBreakInMinutes: 0)
        Task {
            await self.fetchInsightsData(predicate: predicate) { result in
                var timeBreakInMinutes: Int = 0
                var timeFocusedInMinutes: Int = 0
                
                result.forEach { response in
                    // Verifica se a categoria já existe no array de dicionários
                    if let tempoAtual = data.timeFocusedInMinutes[response.category] {
                        // Se a categoria já existe, soma o tempo
                        data.timeFocusedInMinutes[response.category] = tempoAtual + response.focusTimeInMinutes
                    } else {
                        // Se a categoria não existe, adiciona uma nova entrada
                        data.timeFocusedInMinutes[response.category] = response.focusTimeInMinutes
                    }
                    timeBreakInMinutes += response.breakTimeinMinutes
                    timeFocusedInMinutes += response.focusTimeInMinutes
                    
                }
                
                data.timeFocusedInMinutes.forEach({ tag in
                    data.timeFocusedInMinutes[tag.key] = data.timeFocusedInMinutes[tag.key]
                })
                data.value = result.count
                data.timeBreakInMinutes = timeBreakInMinutes
                data.timeTotalInMinutes = timeFocusedInMinutes + timeBreakInMinutes
                
                completion(data)
                
            }
        }
    }
    
    func apliedInsights(insights: InsightsDataModel){
        print(insights)
        presenter?.presentTagInsights(insights: insights)
        presenter?.presentFocusedInsights(insights: insights)
        presenter?.presentSessionInsights(insights: insights)
        presenter?.presenteBreakdownInsights(insights: insights)
        presenter?.presenteTotalTimeInsights(insights: insights)
        
    }
    
    func insightsPerDay() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as CVarArg, endOfDay as CVarArg)
        getInsights(predicate: predicate) { data in
            self.insights = data
            self.apliedInsights(insights: self.insights!)
        }
        
        if let encodedData = try? JSONEncoder().encode(insights) {
            UserDefaults.standard.set(encodedData, forKey: "InsightsDay")
        }else{
            print("Erro ao salvar os insights para notifications")
        }
        
    }
    
    func insightsPerWeek() {
        guard let lastSunday = getLastSunday() else {
            print("Erro ao calcular o último domingo")
            return
        }
        
        let today = Date()
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", lastSunday as CVarArg, today as CVarArg)
        getInsights(predicate: predicate) { data in
            self.insights = data
            self.apliedInsights(insights: self.insights!)
        }
        
        if let encodedData = try? JSONEncoder().encode(insights) {
            UserDefaults.standard.set(encodedData, forKey: "InsightsWeek")
        }else{
            print("Erro ao salvar os insights para notifications")
        }
        
        
    }
    
    func insightsPerMonth(){
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        guard let firstDayOfMonth = calendar.date(from: components) else {return }
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [firstDayOfMonth, currentDate])
        
        getInsights(predicate: predicate) { data in
            self.insights = data
            self.apliedInsights(insights: self.insights!)
        }
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

struct InsightsDataModel: Identifiable, Encodable, Decodable{
    var id = UUID()
    
    var timeFocusedInMinutes: [Tags:Int]
    var timeTotalInMinutes: Int
    var timeBreakInMinutes: Int
    var value: Int?
    
}
