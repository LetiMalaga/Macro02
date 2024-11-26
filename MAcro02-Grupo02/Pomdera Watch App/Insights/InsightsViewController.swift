//
//  InsightsViewController.swift
//  Pomdera Watch App
//
//  Created by Luiz Felipe on 25/11/24.
//

import Foundation
import CloudKit

protocol InsightsViewModelProtocol: AnyObject {
    func fetchInsightsData(predicate: NSPredicate, completion: @escaping ([FocusDataModel]) -> Void) async
    func getInsights(completion: @escaping(InsightsDataModel) -> Void)
}

class InsightsViewModel : InsightsViewModelProtocol, ObservableObject{
    @Published var insightsData: InsightsDataModel?
    private var currentDate: Date = Date()
    
    func fetchInsightsData(predicate: NSPredicate, completion: @escaping ([FocusDataModel]) -> Void) async{
        let dataManager = InsightsData()
        
        Task {
            var focusData: [FocusDataModel] = []
            do{
                let focusResult = try await dataManager.queryTestData(predicate: predicate)
                
                
                focusResult.forEach({ result in
                    if let tagString = result[TimerRecord.tagKey] as? String{
                        let focus = FocusDataModel(focusTimeInMinutes: result[TimerRecord.focusTimeKey] as? Int ?? 0, breakTimeinMinutes: result[TimerRecord.breakTimeKey] as? Int ?? 0, longBreakTimeInMinutes: result[TimerRecord.longBreakTimeKey] as? Int ?? 0, category: tagString, date: result[TimerRecord.dateKey] as? Date ?? Date())
                        focusData.append(focus)
                        
                    }
                })
                completion(focusData)
                DispatchQueue.main.async {
                }
            }
            catch{
                if let error = error as? CKError{
                    switch error.code{
                    case .networkFailure:
                        DispatchQueue.main.async {
                            
                        }
                    case .networkUnavailable:
                        DispatchQueue.main.async {
                            
                        }
                    default :
                        print("error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func getInsights(completion: @escaping (InsightsDataModel) -> Void) {
        var data = InsightsDataModel(
            timeFocusedInMinutes: [],
            timeFocusedTotal: 0,
            timeFocusPerHour: [],
            timeBreakPerHour: [],
            timeTotalInMinutes: 0,
            timeBreakInMinutes: 0
        )
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: currentDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as CVarArg, endOfDay as CVarArg)
        
        Task {
            await self.fetchInsightsData(predicate: predicate) { result in
                result.forEach { response in
                    // Soma por hora
                    let hour = calendar.component(.hour, from: response.date)
                    data.timeFocusPerHour.append(ChartData(hour: hour, value: response.focusTimeInMinutes))
                    data.timeBreakPerHour.append(ChartData(hour: hour, value: response.breakTimeinMinutes))

                    // Soma por categoria
                    if let currentTime = data.timeFocusedInMinutes.first(where: { $0.tag == response.category })?.value,
                       let currentTagIndex = data.timeFocusedInMinutes.firstIndex(where: {$0.tag == response.category}){
                        data.timeFocusedInMinutes[currentTagIndex].value = currentTime + response.focusTimeInMinutes
                    } else {
                        data.timeFocusedInMinutes.append(TagsData(tag: response.category, value: response.focusTimeInMinutes))
                    }

                    // Soma total de intervalos
                    data.timeBreakInMinutes += response.breakTimeinMinutes + response.longBreakTimeInMinutes
                    data.timeTotalInMinutes += response.focusTimeInMinutes + response.breakTimeinMinutes + response.longBreakTimeInMinutes
                    data.timeFocusedTotal += response.focusTimeInMinutes
                }
                
                completion(data)
            }
        }
    }
    
    func formatMinutesToHours(minutes: Int) -> String {
        let hours = minutes / 60
            let remainingMinutes = minutes % 60
        return minutes<60 ? "\(minutes) min" : "\(hours) h \(remainingMinutes) min"
    }
    
    func dateFormatter() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM" // "dd" para o dia e "MMM" para o mês abreviado
        formatter.locale = Locale(identifier: "pt_BR") // Define o idioma como português do Brasil
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
}

enum PreriodInsights{
    case day
    case week
    case month
}

struct FocusDataModel: Identifiable{
    var id = UUID()
    var focusTimeInMinutes: Int
    var breakTimeinMinutes: Int
    var longBreakTimeInMinutes: Int
    var category: String
    var date: Date
    
}

struct InsightsDataModel: Identifiable {
    var id = UUID()
    var timeFocusedInMinutes: [TagsData] // Categoria e minutos focados
    var timeFocusedTotal: Int // Categoria e minutos focados
    var timeFocusPerHour: [ChartData] // Hora e minutos focados
    var timeBreakPerHour: [ChartData] // Hora e minutos focados
    var timeTotalInMinutes: Int
    var timeBreakInMinutes: Int
    var value: Int?
}

struct ChartData: Identifiable, Hashable {
    var id = UUID()
    var hour: Int
    var value: Int
}

struct TagsData: Identifiable, Hashable  {
    var id = UUID()
    var tag: String
    var value: Int
}
