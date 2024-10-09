//
//  InsightsPresenter.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 27/09/24.
//

import Foundation
import UIKit

protocol InsightsPresenterProtocol {
    func presentTagInsights(insights: InsightsDataModel)
    func presentFocusedInsights(insights: InsightsDataModel)
    func presenteBreakdownInsights(insights: InsightsDataModel)
    func presentSessionInsights(insights: InsightsDataModel)
    func presenteTotalTimeInsights(insights: InsightsDataModel)
}

class InsightsPresenter: InsightsPresenterProtocol {
    private var view: InsightsViewProtocol?
    
    init(view: InsightsViewProtocol) {
        self.view = view
    }
    
    func presentTagInsights(insights: InsightsDataModel) {
        let tags = insights.timeFocusedInMinutes
    
        
    }
    
    func presentFocusedInsights(insights: InsightsDataModel) {
        let timeInHours = convertMinutesToHours(minutes: insights.timeFocusedInMinutes.values.reduce(0, +))
    }
    
    func presenteBreakdownInsights(insights: InsightsDataModel) {
        let timeInHours = convertMinutesToHours(minutes: insights.timeBreakInMinutes)
    }
    func presentSessionInsights(insights: InsightsDataModel) {
        let totalSessions = insights.value
    }
    
    func presenteTotalTimeInsights(insights: InsightsDataModel) {
        let totalTime = insights.timeTotalInMinutes
    }
    
    func convertMinutesToHours(minutes: Int) -> Double {
        let hours = minutes / 60               
        let remainingMinutes = minutes % 60
        let decimalMinutes = Double(remainingMinutes) / 60.0
        
        return Double(hours) + decimalMinutes
    }
}
