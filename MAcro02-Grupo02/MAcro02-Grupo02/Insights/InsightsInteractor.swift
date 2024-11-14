//
//  InsightsInteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 25/09/24.
//

import Foundation
import CloudKit

protocol InsightsInteractorProtocol: AnyObject {
    var insights: InsightsDataModel? { get }
    var presenter: InsightsPresenterProtocol? { get }
    
    func fetchInsightsData(predicate: NSPredicate, completion: @escaping ([FocusDataModel]) -> Void) async
    func getInsights(predicate: NSPredicate, completion: @escaping(InsightsDataModel) -> Void)
    
    func insightsPerDay()
    func insightsPerMonth()
    func insightsPerWeek()
    
    func advanceDay()
    func rewindDay()
    
    func advanceWeek()
    func rewindWeek()
    
    func advanceMonth()
    func rewindMonth()
    
    
    func updateDayDescription()
    func updateWeekDescription()
    func updateMonthDescription()
}


class InsightsInteractor : InsightsInteractorProtocol {
    
    var presenter: InsightsPresenterProtocol?
    var insights: InsightsDataModel?
    
    // Variáveis de controle de data para dia, semana e mês
    private var currentDate: Date = Date()  // Para controle diário
    private var currentWeekStartDate: Date = Date()  // Para controle semanal
    private var currentMonthStartDate: Date = Date()  // Para controle mensal
    
    // Limites de avanço e recuo
    private let maxDaysBack = 7
    private let maxWeeksBack = 4
    private var minMonthStartDate: Date? // Calculado com base nos dados disponíveis
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")  // Locale para exibir o texto em português
        return formatter
    }()
    
    init() {
        fetchEarliestDateWithData()  // Implementar esta função para determinar a data mais antiga com dados
    }
    
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
                    self.presenter?.showConnectionError(true)
                }
            }
            catch{
                if let error = error as? CKError{
                    switch error.code{
                    case .networkFailure:
                        DispatchQueue.main.async {
                            self.presenter?.showConnectionError(false)
                        }
                    case .networkUnavailable:
                        DispatchQueue.main.async {
                            self.presenter?.showConnectionError(false)
                        }
                    default :
                        print("error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func getInsights(predicate: NSPredicate, completion: @escaping (InsightsDataModel) -> Void) {
        var data: InsightsDataModel = InsightsDataModel(timeFocusedInMinutes: [:], timeTotalInMinutes: 0, timeBreakInMinutes: 0)
        presenter?.isLoding(true)
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
                    timeBreakInMinutes += response.longBreakTimeInMinutes
                    timeFocusedInMinutes += response.focusTimeInMinutes
                    
                }
                
                data.timeFocusedInMinutes.forEach({ tag in
                    data.timeFocusedInMinutes[tag.key] = data.timeFocusedInMinutes[tag.key]
                })
                data.value = result.count
                data.timeBreakInMinutes = timeBreakInMinutes
                data.timeTotalInMinutes = timeFocusedInMinutes + timeBreakInMinutes
                
                DispatchQueue.main.async {
                    self.presenter?.isLoding(false)
                }
                completion(data)
                
            }
        }
    }
    
    func apliedInsights(insights: InsightsDataModel){
        presenter?.presentTagInsights(insights: insights)
        presenter?.presentFocusedInsights(insights: insights)
        presenter?.presentSessionInsights(insights: insights)
        presenter?.presenteBreakdownInsights(insights: insights)
        presenter?.presenteTotalTimeInsights(insights: insights)
        
    }
    func insightsPerDay() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: currentDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as CVarArg, endOfDay as CVarArg)
        updateDayDescription()
        getInsights(predicate: predicate) { data in
            self.insights = data
            self.apliedInsights(insights: self.insights!)
            self.faceIconChange(data.value ?? 0, period: .day)
        }
    }
    
    func insightsPerWeek() {
        let calendar = Calendar.current
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: currentWeekStartDate)!
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", currentWeekStartDate as CVarArg, endOfWeek as CVarArg)
        updateWeekDescription()
        getInsights(predicate: predicate) { data in
            self.insights = data
            self.apliedInsights(insights: self.insights!)
            self.faceIconChange(data.value ?? 0, period: .week)
        }
    }
    
    func insightsPerMonth() {
        let calendar = Calendar.current
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: currentMonthStartDate)!
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", currentMonthStartDate as CVarArg, endOfMonth as CVarArg)
        updateMonthDescription()
        getInsights(predicate: predicate) { data in
            self.insights = data
            self.apliedInsights(insights: self.insights!)
            self.faceIconChange(data.value ?? 0, period: .month)
        }
        
    }
    
    // Atualiza a data para o próximo dia e chama insightsPerDay
    // Avança um dia se ainda não estiver na data atual
    func advanceDay() {
        let today = Calendar.current.startOfDay(for: Date())
        if currentDate < today {
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            insightsPerDay()
        }
    }
    
    // Retrocede um dia se não ultrapassar o limite máximo
    func rewindDay() {
        let maxPastDate = Calendar.current.date(byAdding: .day, value: -maxDaysBack, to: Date())!
        if currentDate > maxPastDate {
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            insightsPerDay()
        }
    }
    
    func advanceWeek() {
        let startOfWeek = getLastSunday(from: Date())
        if currentWeekStartDate < startOfWeek {
            currentWeekStartDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentWeekStartDate)!
            insightsPerWeek()
        }
    }
    
    func rewindWeek() {
        let maxPastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -maxWeeksBack, to: Date())!
        if currentWeekStartDate > maxPastWeekDate {
            currentWeekStartDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentWeekStartDate)!
            insightsPerWeek()
        }
    }
    
    func advanceMonth() {
        let startOfCurrentMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
        if currentMonthStartDate < startOfCurrentMonth {
            currentMonthStartDate = Calendar.current.date(byAdding: .month, value: 1, to: currentMonthStartDate)!
            insightsPerMonth()
        }
    }
    
    func rewindMonth() {
        if let minMonthStartDate = minMonthStartDate, currentMonthStartDate > minMonthStartDate {
            currentMonthStartDate = Calendar.current.date(byAdding: .month, value: -1, to: currentMonthStartDate)!
            insightsPerMonth()
        }
    }
    
    
    // Função para atualizar o texto do período de dia
    func updateDayDescription() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        var timeDescription : String
        
        if calendar.isDate(currentDate, inSameDayAs: today) {
            timeDescription = "Hoje"
        } else if calendar.isDate(currentDate, inSameDayAs: yesterday) {
            timeDescription = "Ontem"
        } else {
            dateFormatter.dateFormat = "dd 'de' MMM 'de' yy"
            timeDescription = dateFormatter.string(from: currentDate)
        }
        
        presenter?.updateDayDescriptionText(timeDescription)
    }
    
    // Função para atualizar o texto do período de semana
    func updateWeekDescription() {
        let calendar = Calendar.current
        let startOfWeek = getLastSunday(from: Date())
        let endOfCurrentWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        let previousWeekStart = calendar.date(byAdding: .day, value: -7, to: startOfWeek)!
        var timeDescription : String
        
        if currentWeekStartDate == startOfWeek {
            timeDescription = "Esta semana"
        } else if currentWeekStartDate == previousWeekStart {
            timeDescription = "Semana passada"
        } else {
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: currentWeekStartDate)!
            dateFormatter.dateFormat = "dd 'de' MMM"
            let startDate = dateFormatter.string(from: currentWeekStartDate)
            let endDate = dateFormatter.string(from: endOfWeek)
            dateFormatter.dateFormat = "yy"
            let year = dateFormatter.string(from: currentWeekStartDate)
            timeDescription = "\(startDate) a \(endDate) \(year)"
        }
        presenter?.updateWeekDescriptionText(timeDescription)
    }
    
    // Função para atualizar o texto do período de mês
    func updateMonthDescription() {
        let calendar = Calendar.current
        let currentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
        var timeDescription : String
        
        if currentMonthStartDate == currentMonth {
            timeDescription = "Este mês"
        } else if currentMonthStartDate == previousMonth {
            timeDescription = "Mês passado"
        } else {
            dateFormatter.dateFormat = "MMMM 'de' yyyy"
            timeDescription = dateFormatter.string(from: currentMonthStartDate).capitalized
        }
        
        presenter?.updateMonthDescriptionText(timeDescription)
    }
    
    private func getLastSunday(from date: Date) -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let daysToLastSunday = (weekday == 1) ? 0 : weekday - 1
        return calendar.date(byAdding: .day, value: -daysToLastSunday, to: date)!
    }
    
    private func fetchEarliestDateWithData() {
        let dataManager = InsightsData()
        dataManager.fetchEarliestDateWithData { [weak self] date in
            self?.minMonthStartDate = date
        }
    }
    
    private func faceIconChange(_ sessions: Int, period: PreriodInsights) {
        var faceIcon: FaceIcon
        switch period {
        case .day:
            if sessions <= 1 {
                faceIcon = .RedFaceInsights
            }else if sessions == 2{
                faceIcon = .OrangeFaceInsights
            }else if sessions == 3 {
                faceIcon = .BlueFaceInsights
            }else{
                faceIcon = .GreenFaceInsights
            }
        case .week:
            if sessions <= 2 {
                faceIcon = .RedFaceInsights
            }else if sessions >= 3 && sessions <= 5{
                faceIcon = .OrangeFaceInsights
            }else if sessions >= 6 && sessions <= 8 {
                faceIcon = .BlueFaceInsights
            }else{
                faceIcon = .GreenFaceInsights
            }
        case .month:
            if sessions <= 6 {
                faceIcon = .RedFaceInsights
            }else if sessions >= 6 && sessions <= 10{
                faceIcon = .OrangeFaceInsights
            }else if sessions >= 11 && sessions <= 15 {
                faceIcon = .BlueFaceInsights
            }else{
                faceIcon = .GreenFaceInsights
            }
        }
        DispatchQueue.main.async {
            self.presenter?.updateFaceIcon(faceIcon)
        }
    }
    
}

enum PreriodInsights{
    case day
    case week
    case month
}

struct FocusDataModel: Identifiable, Encodable, Decodable {
    var id = UUID()
    var focusTimeInMinutes: Int
    var breakTimeinMinutes: Int
    var longBreakTimeInMinutes: Int
    var category: String
    var date: Date
    
}

struct InsightsDataModel: Identifiable, Encodable, Decodable{
    var id = UUID()
    
    var timeFocusedInMinutes: [String:Int]
    var timeTotalInMinutes: Int
    var timeBreakInMinutes: Int
    var value: Int?
    
}
