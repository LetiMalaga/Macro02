//
//  ActivitiesPresenterTests.swift
//  MAcro02-Grupo02Tests
//
//  Created by Luiz Felipe on 23/09/24.
//

import XCTest

@testable import MAcro02_Grupo02


final class ActivitiesPresenterTests: XCTestCase {
    
    func testUploadActivitys() {
        let viewMock = ActivitiesViewMock()
        let presenter = ActivitiesPresenter(view: viewMock)
        
        let expectation = self.expectation(description: "uploadActivity")
        
        let activities = [ActivitiesModel(tittle: "teste1"), ActivitiesModel(tittle: "teste2"), ActivitiesModel(tittle: "teste3")]
        presenter.uploadActivitys(activities)
        
        XCTAssertTrue(viewMock.activities.count == 3)
        XCTAssertTrue(viewMock.activities.contains(where: {$0.tittle == "teste1"}))
        XCTAssertTrue(viewMock.activities.contains(where: {$0.tittle == "teste2"}))
        XCTAssertTrue(viewMock.activities.contains(where: {$0.tittle == "teste3"}))
        XCTAssertTrue(viewMock.isReloadDataCalled)
        
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReturnActivity() {
        let viewMock = ActivitiesViewMock()
        let presenter = ActivitiesPresenter(view: viewMock)
    
        let expectation = self.expectation(description: "returnActivity")
        
        let activity = ActivitiesModel(tittle: "Teste")
        presenter.returnActivity(activity: activity)
        
        XCTAssertTrue(viewMock.selectededActivity?.tittle == activity.tittle)
        
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDeleteActivity() {
        let viewMock = ActivitiesViewMock()
        let presenter = ActivitiesPresenter(view: viewMock)
    
        let expectation = self.expectation(description: "deleteActivity")
        
        let activity = ActivitiesModel(tittle: "Teste")
        viewMock.activities.append(activity)
        if let index = viewMock.activities.firstIndex(where: {$0.tittle == "Teste"}){
            XCTAssertTrue(index < viewMock.activities.count)
            presenter.deleteActivity(at: index)
            XCTAssertFalse(viewMock.activities.contains(where: {$0.tittle == "Teste"}))
        }
        
        XCTAssertTrue(viewMock.isReloadDataCalled)
        
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    
}

class ActivitiesViewMock: ActivitiesViewProtocol {
    var activities: [ActivitiesModel] = [ActivitiesModel(tittle: "Study"), ActivitiesModel(tittle: "Work"), ActivitiesModel(tittle: "Exercise")]
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
