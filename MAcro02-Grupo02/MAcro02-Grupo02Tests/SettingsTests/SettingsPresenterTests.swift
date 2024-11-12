//
//  SettingsPresenterTests.swift
//  MAcro02-Grupo02Tests
//
//  Created by Luiz Felipe on 30/10/24.
//

import XCTest
@testable import MAcro02_Grupo02

final class SettingsPresenterTests: XCTestCase {

    func testUploadActivitys() {
        let viewMock = SettingsViewMock()
        let presenter = SettingsPresenter()
        presenter.view = viewMock
        
        let expectation = self.expectation(description: "uploadActivity")
        
        let activities = [ActivitiesModel(tittle: "teste1"), ActivitiesModel(tittle: "teste2"), ActivitiesModel(tittle: "teste3")]
        presenter.uploadActivitys(activities)
        
        XCTAssertTrue(viewMock.activitys.count == 3)
        XCTAssertTrue(viewMock.activitys.contains(where: {$0.tittle == "teste1"}))
        XCTAssertTrue(viewMock.activitys.contains(where: {$0.tittle == "teste2"}))
        XCTAssertTrue(viewMock.activitys.contains(where: {$0.tittle == "teste3"}))
        XCTAssertTrue(viewMock.isReloadDataCalled)
        
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReturnActivity() {
        let viewMock = SettingsViewMock()
        let presenter = SettingsPresenter()
        presenter.view = viewMock
    
        let expectation = self.expectation(description: "returnActivity")
        
        let activity = ActivitiesModel(tittle: "Teste")
        presenter.returnActivity(activity: activity)
        
        XCTAssertTrue(viewMock.selectededActivity?.tittle == activity.tittle)
        
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDeleteActivity() {
        let viewMock = SettingsViewMock()
        let presenter = SettingsPresenter()
        presenter.view = viewMock
    
        let expectation = self.expectation(description: "deleteActivity")
        
        let activity = ActivitiesModel(tittle: "Teste")
        viewMock.activitys.append(activity)
        if let index = viewMock.activitys.firstIndex(where: {$0.tittle == "Teste"}){
            XCTAssertTrue(index < viewMock.activitys.count)
            presenter.deleteActivity(at: index)
            XCTAssertFalse(viewMock.activitys.contains(where: {$0.tittle == "Teste"}))
        }
        
        XCTAssertTrue(viewMock.isReloadDataCalled)
        
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    
}

class SettingsViewMock: SettingsViewProtocol {
    var soundButton: Bool = true
    
    var vibrationButton: Bool = true
    
    var breathingButton: Bool = true
    
    var recommendationButton: Bool = true
        
    var activitys: [ActivitiesModel] = [ActivitiesModel(tittle: "Study"), ActivitiesModel(tittle: "Work"), ActivitiesModel(tittle: "Exercise")]
    var selectededActivity: ActivitiesModel?
    
    var isReloadDataCalled: Bool = false
    var showActivityDetailCalled: Bool = false
    
    func reloadData() {
        self.isReloadDataCalled = true
        print("reloadData called")
    }
    
    func showActivityDetail(_ activity:ActivitiesModel) {
        self.showActivityDetailCalled = true
        self.selectededActivity = activity
        print("showActivityDetail called")
    }
    
    
}
