//
//  PresenterInsightsTest.swift
//  MAcro02-Grupo02Tests
//
//  Created by Luiz Felipe on 07/10/24.
//

import XCTest
@testable import MAcro02_Grupo02
final class PresenterInsightsTest: XCTestCase {
    
    func testPresentTagInsights() {
        
        let presenter = InsightsPresenter()
        
    
        
    }
    
    func testPresentFocusedInsights() {
        let timeInHours = convertMinutesToHours(minutes: insights.timeFocusedInMinutes.values.reduce(0, +))
    }
    
    func testPresenteBreakdownInsights() {
        let timeInHours = convertMinutesToHours(minutes: insights.timeBreakInMinutes)
    }
    func testPresentSessionInsights(insights: InsightsDataModel) {
        let totalSessions = insights.value
    }
    
    func testPresenteTotalTimeInsights() {
        let totalTime = insights.timeTotalInMinutes
    }

}
