//
//  InsightsInteractorTests.swift
//  MAcro02-Grupo02Tests
//
//  Created by Luiz Felipe on 27/09/24.
//

import XCTest
@testable import MAcro02_Grupo02

final class InsightsInteractorTests: XCTestCase {
    
    func testQueryInsights(){
        let mockData = InsightsDataMock()
        let mockPresenter = InsightsPresenterMock()
        let expectation = self.expectation(description: "Query insights")
        // Act
        mockData.queryTestData { result in
            switch result {
            case .success(let data):
                // Assert
                switch data {
                case .success(let data):
                    XCTAssertTrue(!data.isEmpty)
                case .failure:
                    XCTFail()
                }
                
                
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1.0)
       
    }
}

class InsightsDataMock{
    func queryTestData(closure: @escaping (Result<Result<[String], Error>, Error>)-> Void){
        let result: Result<Result<[String], Error>, Error> = .success(.success(["test", "test2", "test3", "test4", "test5"]))
        closure(result)
        
    }
}

class InsightsPresenterMock:InsightsPresenterProtocol{
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
        let hours = minutes / 60               // Parte inteira: horas
        let remainingMinutes = minutes % 60    // Minutos restantes
        let decimalMinutes = Double(remainingMinutes) / 60.0 // Fração de hora
        
        return Double(hours) + decimalMinutes
    }
    
    
}
