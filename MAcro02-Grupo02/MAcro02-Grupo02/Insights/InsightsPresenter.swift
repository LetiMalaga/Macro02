//
//  InsightsPresenter.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 27/09/24.
//

import Foundation
import SwiftUI
import UIKit

protocol InsightsPresenterProtocol {
    var view: InsightsViewProtocol? { get }
    
    func presentTagInsights(insights: InsightsDataModel)
    func presentFocusedInsights(insights: InsightsDataModel)
    func presenteBreakdownInsights(insights: InsightsDataModel)
    func presentSessionInsights(insights: InsightsDataModel)
    func presenteTotalTimeInsights(insights: InsightsDataModel)
    
    func updateDayDescriptionText(_ description: String)
    func updateWeekDescriptionText(_ description: String)
    func updateMonthDescriptionText(_ description: String)
    
    func updateFaceIcon(_ faceIcon: FaceIcon)
    func isLoding(_ status: Bool)
    func showConnectionError(_ hasConnection: Bool)
}

class InsightsPresenter: InsightsPresenterProtocol {
    var view: InsightsViewProtocol?
    
    func presentTagInsights(insights: InsightsDataModel) {
        var formatData:[ChartData] = []
        insights.timeFocusedInMinutes.forEach { key, value in
            formatData.append(ChartData(type: key, count: value))
        }
        DispatchQueue.main.async {
            withAnimation {
                self.view?.data.tags = formatData
            }
        }
        
    }
    
    func presentFocusedInsights(insights: InsightsDataModel) {
        let time = insights.timeFocusedInMinutes.values.reduce(0, +)
        if time > 60 {
            let timeInHours = formatMinutesToHours(minutes: time)
            DispatchQueue.main.async {
                withAnimation {
                    self.view?.data.foco = timeInHours
                }
            }
        }else{
            DispatchQueue.main.async {
                withAnimation {
                    self.view?.data.foco = String(format: "%d min", time)
                }
            }
        }
    }
    
    func presenteBreakdownInsights(insights: InsightsDataModel) {
        let time = insights.timeBreakInMinutes
        if time > 60 {
            let timeInHours = formatMinutesToHours(minutes: time)
            DispatchQueue.main.async {
                withAnimation {
                    self.view?.data.pause = timeInHours
                }
            }
        }else{
            DispatchQueue.main.async {
                withAnimation {
                    self.view?.data.pause = String(format: "%d min", time)
                }
            }
        }
    }
    func presentSessionInsights(insights: InsightsDataModel) {
        let totalSessions = insights.value
        DispatchQueue.main.async {
            withAnimation {
                self.view?.data.session = totalSessions ?? 0
            }
        }
    }
    
    func presenteTotalTimeInsights(insights: InsightsDataModel) {
        let time = insights.timeTotalInMinutes
        if time > 60 {
            let timeInHours = formatMinutesToHours(minutes: time)
            DispatchQueue.main.async {
                withAnimation {
                    self.view?.data.total = timeInHours
                }
            }
        }else{
            DispatchQueue.main.async {
                withAnimation {
                    self.view?.data.total = String(format: "%d min", time)
                }
            }
        }
    }
    
    func isLoding(_ status: Bool) {
        withAnimation {
            view?.data.isLoading = status
        }
    }
    
    func formatMinutesToHours(minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return String(format: "%d:%02d h", hours, remainingMinutes)
    }
    
    func updateDayDescriptionText(_ description: String) {
        withAnimation {
            view?.data.textDescriptionDate = description
        }
    }
    
    func updateWeekDescriptionText(_ description: String) {
        withAnimation {
            view?.data.textDescriptionDate = description
        }
    }
    
    func updateMonthDescriptionText(_ description: String) {
        withAnimation {
            view?.data.textDescriptionDate = description
        }
    }
    func updateFaceIcon(_ faceIcon: FaceIcon){
        withAnimation {
            view?.data.faceIcon = faceIcon.rawValue
        }
    }
    func showConnectionError(_ hasConnection: Bool){
        view?.data.showConnectionError = !hasConnection
    }
}

enum FaceIcon: String, CaseIterable {
    case RedFaceInsights
    case OrangeFaceInsights
    case GreenFaceInsights
    case BlueFaceInsights
}
