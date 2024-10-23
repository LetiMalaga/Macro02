//
//  InsightsPresenter.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 27/09/24.
//

import Foundation
import UIKit

protocol InsightsPresenterProtocol {
    var view: InsightsViewProtocol? { get }
    
    func presentTagInsights(insights: InsightsDataModel)
    func presentFocusedInsights(insights: InsightsDataModel)
    func presenteBreakdownInsights(insights: InsightsDataModel)
    func presentSessionInsights(insights: InsightsDataModel)
    func presenteTotalTimeInsights(insights: InsightsDataModel)
}

class InsightsPresenter: InsightsPresenterProtocol {
    var view: InsightsViewProtocol?
    
//    init(view: InsightsViewProtocol) {
//        self.view = view
//    }
    
    func presentTagInsights(insights: InsightsDataModel) {
        var formatData:[ChartData] = []
        insights.timeFocusedInMinutes.forEach { key, value in
            formatData.append(ChartData(type: key.rawValue, count: value))
        }
        
        view?.data?.tags = formatData
        
    }
    
    func presentFocusedInsights(insights: InsightsDataModel) {
        var time = insights.timeFocusedInMinutes.values.reduce(0, +)
        if time > 60 {
            let timeInHours = formatMinutesToHours(minutes: time)
            view?.data?.foco = timeInHours
        }else{
            view?.data?.foco = String(format: "%d min", time)
        }
    }
    
    func presenteBreakdownInsights(insights: InsightsDataModel) {
        var time = insights.timeBreakInMinutes
        if time > 60 {
            let timeInHours = formatMinutesToHours(minutes: time)
            view?.data?.pause = timeInHours
        }else{
            view?.data?.pause = String(format: "%d min", time)
        }
    }
    func presentSessionInsights(insights: InsightsDataModel) {
        let totalSessions = insights.value
        view?.data?.session = totalSessions ?? 0
    }
    
    func presenteTotalTimeInsights(insights: InsightsDataModel) {
        var time = insights.timeTotalInMinutes
        if time > 60 {
            let timeInHours = formatMinutesToHours(minutes: time)
            view?.data?.total = timeInHours
        }else{
            view?.data?.total = String(format: "%d min", time)
        }
    }
    
    func formatMinutesToHours(minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return String(format: "%d:%02d h", hours, remainingMinutes)
    }
}
