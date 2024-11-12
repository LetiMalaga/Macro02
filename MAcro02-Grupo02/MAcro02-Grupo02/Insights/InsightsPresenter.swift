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
    
    func presentTagInsights(insights: InsightsDataModel) {
        var formatData:[ChartData] = []
        insights.timeFocusedInMinutes.forEach { key, value in
            formatData.append(ChartData(type: key.rawValue, count: value))
        }
        DispatchQueue.main.async {
            self.view?.data.tags = formatData
        }
        
    }
    
    func presentFocusedInsights(insights: InsightsDataModel) {
        let time = insights.timeFocusedInMinutes.values.reduce(0, +)
        if time > 60 {
            let timeInHours = formatMinutesToHours(minutes: time)
            DispatchQueue.main.async {
                self.view?.data.foco = timeInHours
            }
        }else{
            DispatchQueue.main.async {
                self.view?.data.foco = String(format: "%d min", time)
            }
        }
    }
    
    func presenteBreakdownInsights(insights: InsightsDataModel) {
        let time = insights.timeBreakInMinutes
        if time > 60 {
            let timeInHours = formatMinutesToHours(minutes: time)
            DispatchQueue.main.async {
                self.view?.data.pause = timeInHours
            }
        }else{
            DispatchQueue.main.async {
                self.view?.data.pause = String(format: "%d min", time)
            }
        }
    }
    func presentSessionInsights(insights: InsightsDataModel) {
        let totalSessions = insights.value
        DispatchQueue.main.async {
            self.view?.data.session = totalSessions ?? 0
        }
    }
    
    func presenteTotalTimeInsights(insights: InsightsDataModel) {
        let time = insights.timeTotalInMinutes
        if time > 60 {
            let timeInHours = formatMinutesToHours(minutes: time)
            DispatchQueue.main.async {
                self.view?.data.total = timeInHours
            }
        }else{
            DispatchQueue.main.async {
                self.view?.data.total = String(format: "%d min", time)
            }
        }
    }
    
    func formatMinutesToHours(minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return String(format: "%d:%02d h", hours, remainingMinutes)
    }
}
