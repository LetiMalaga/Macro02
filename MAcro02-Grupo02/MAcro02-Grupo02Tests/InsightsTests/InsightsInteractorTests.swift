//
//  InsightsInteractorTests.swift
//  MAcro02-Grupo02Tests
//
//  Created by Luiz Felipe on 27/09/24.
//

import XCTest
@testable import MAcro02_Grupo02
import CloudKit

final class InsightsInteractorTests: XCTestCase {
    
    func testFetchInsightsDataCallsQueryTestData(){
        let mockData = MockInsightsData()
        let mockPresenter = MockInsightsPresenter()
        let interactor = InsightsInteractor()
        
        let expectation = self.expectation(description: "queryInsights")
        
        let predicate = NSPredicate(format: "data == %@", Date() as CVarArg)
        
        Task{
             await interactor.fetchInsightsData(predicate: predicate) { _ in
                XCTAssertTrue(mockData.queryTestDataCalled, "O método queryTestData deveria ter sido chamado.")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testInsightsPerDayPresentsData(){
        let mockData = MockInsightsData()
        let mockPresenter = MockInsightsPresenter()
        let interactor = InsightsInteractor()

        let expectation = self.expectation(description: "queryInsights")
        
        let predicate = NSPredicate(format: "data == %@", Date() as CVarArg)
        
        let mockFocusData = FocusDataModel(focusTimeInMinutes: 30, breakTimeinMinutes: 10, category: .relax, date: Date())
        mockData.mockResult = [
            (CKRecord.ID(recordName: "test"), .success(CKRecord(recordType: "TimerRecord")))
        ]
        
        interactor.insightsPerDay()
        
        XCTAssertTrue(mockPresenter.insightsPresented, "Os insights deveriam ter sido apresentados pelo presenter.")
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockInsightsData {
    
    var queryTestDataCalled = false
    var mockResult: [(CKRecord.ID, Result<CKRecord, any Error>)] = []
    
    func queryTestData(predicate: NSPredicate, closure: @escaping ([(CKRecord.ID, Result<CKRecord, any Error>)]) -> Void) {
        queryTestDataCalled = true
        closure(mockResult)
    }
}

// Mock para o protocolo InsightsPresenterProtocol
class MockInsightsPresenter: InsightsPresenterProtocol {
    var view: (any MAcro02_Grupo02.InsightsViewProtocol)?
    
    var insightsPresented = false
    
    func presentTagInsights(insights: InsightsDataModel) {
        insightsPresented = true
    }
    
    func presentFocusedInsights(insights: InsightsDataModel) {}
    func presentSessionInsights(insights: InsightsDataModel) {}
    func presenteBreakdownInsights(insights: InsightsDataModel) {}
    func presenteTotalTimeInsights(insights: InsightsDataModel) {}
}
