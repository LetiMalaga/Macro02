//
//  SettingsInteractorTests.swift
//  MAcro02-Grupo02Tests
//
//  Created by Luiz Felipe on 30/10/24.
//

import XCTest
@testable import MAcro02_Grupo02

final class SettingsInteractorTests: XCTestCase {
    func testFetchActivitiesSuccess() {
        let mockActivitiesData = SettingsDataMock()
        let mockActivitiesPresenter = SettingsPresenterMock()
        let interactor = SettingsIteractor()
        interactor.presenter = mockActivitiesPresenter
        interactor.dataModel = mockActivitiesData
        
        let expectation = self.expectation(description: "fetchActivities")
        
        interactor.fetchActivities()
        XCTAssertFalse(interactor.activities.isEmpty)
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func testAddActivitie() {
        let mockActivitiesData = SettingsDataMock()
        let mockActivitiesPresenter = SettingsPresenterMock()
        let interactor = SettingsIteractor()
        interactor.presenter = mockActivitiesPresenter
        interactor.dataModel = mockActivitiesData
        
        let expectation = self.expectation(description: "addActivities")
        
        let activity = ActivitiesModel(tittle: "Study")
        interactor.addActivity(activity)
        
        XCTAssertFalse(interactor.activities.contains(where: { activity in
            activity.tittle == activity.tittle
        }))
        
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDeleteActivity() {
        let mockActivitiesData = SettingsDataMock()
        let mockActivitiesPresenter = SettingsPresenterMock()
        let interactor = SettingsIteractor()
        interactor.presenter = mockActivitiesPresenter
        interactor.dataModel = mockActivitiesData
        
        let expectation = self.expectation(description: "deleteActivity")
        
        let activity = ActivitiesModel(tittle: "Teste")
        interactor.addActivity(activity)
        
        if let index = interactor.activities.firstIndex(where: { $0.tittle == "Teste"}){
            XCTAssertTrue(index < interactor.activities.count)
            interactor.deleteActivity(at: index)
            XCTAssertFalse(interactor.activities.contains(where: {$0.tittle == "Teste"}))
        }
        
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func testValidateActivityName() {
        let mockActivitiesData = SettingsDataMock()
        let mockActivitiesPresenter = SettingsPresenterMock()
        let interactor = SettingsIteractor()
        interactor.presenter = mockActivitiesPresenter
        interactor.dataModel = mockActivitiesData
        
        let expectation = self.expectation(description: "validateActivityName")
        
        let name = "Study"
        XCTAssertTrue(interactor.validateActivityName(name))
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}

class SettingsDataMock: SettingsDataProtocol{
    
    var mockActivities = [ActivitiesModel(tittle: "Study"), ActivitiesModel(tittle: "Work"), ActivitiesModel(tittle: "Exercise")]
    var shouldReturnError = false
    
    func fetchActivities(completion: @escaping ([ActivitiesModel]) -> Void) {
        if shouldReturnError {
            completion([])
        } else {
            completion(mockActivities)
        }
    }
    
    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void) {
        if !shouldReturnError{
            mockActivities.append(activity)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func deleteActivity(at id: UUID, completion: @escaping (Bool) -> Void) {
        if let index = mockActivities.firstIndex(where: { $0.id == id }) {
            if shouldReturnError {
                completion(false)
            }else{
                mockActivities.remove(at: index)
                completion(true)
            }
        } else {
            completion(false)
        }
    }
    
}
class SettingsPresenterMock: SettingsPresenterProtocol {
    func uploadActivitys(_ activity: [MAcro02_Grupo02.ActivitiesModel]) {
        <#code#>
    }
    
    func addActivity(_ activity: MAcro02_Grupo02.ActivitiesModel) {
        <#code#>
    }
    
    func returnActivity(activity: MAcro02_Grupo02.ActivitiesModel) {
        <#code#>
    }
    
    func deleteActivity(at index: Int) {
        <#code#>
    }
    
    func toggleButtonSound(value: Bool) {
        <#code#>
    }
    
    func toggleButtonVibration(value: Bool) {
        <#code#>
    }
    
    func toggleButtonBreathing(value: Bool) {
        <#code#>
    }
    
    func toggleButtonRecomendation(value: Bool) {
        <#code#>
    }
    
    
    
}
