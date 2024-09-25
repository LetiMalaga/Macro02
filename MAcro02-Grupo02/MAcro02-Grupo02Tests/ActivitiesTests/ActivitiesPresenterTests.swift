//
//  ActivitiesPresenterTests.swift
//  MAcro02-Grupo02Tests
//
//  Created by Luiz Felipe on 23/09/24.
//

import XCTest

@testable import MAcro02_Grupo02


final class ActivitiesPresenterTests: XCTestCase {
    
    
    func testViewDidLoadCallsFetchActivitiesAndReloadsData() {
        let viewMock = ActivitiesViewMock()
        let interactorMock = ActivitiesInteractorMock()
        let presenter = ActivitiesPresenter(view: viewMock, activitiesInteractor: interactorMock)
        
        // Act
        presenter.viewDidLoad()
        
        // Assert
        XCTAssertTrue(interactorMock.fetchActivitiesCalled, "fetchActivities should have been called")
        XCTAssertTrue(viewMock.isReloadDataCalled, "reloadData should have been called")
    }
    
    func testAddNewActivity() {
        let viewMock = ActivitiesViewMock()
        let interactorMock = ActivitiesInteractorMock()
        let presenter = ActivitiesPresenter(view: viewMock, activitiesInteractor: interactorMock)
        
        // Arrange
        let newActivity = ActivitiesModel(tittle: "Exercise")
        
        // Act
        presenter.addNewActivity(newActivity)
        
        // Assert
        XCTAssertTrue(interactorMock.addActivityCalled, "addActivity should have been called")
        XCTAssertTrue(viewMock.isReloadDataCalled, "reloadData should have been called after adding a new activity")
    }
    
    func testDeleteActivity() {
        let viewMock = ActivitiesViewMock()
        let interactorMock = ActivitiesInteractorMock()
        let presenter = ActivitiesPresenter(view: viewMock, activitiesInteractor: interactorMock)
        
        // Act
        presenter.deleteActivity(at: 0)
        
        // Assert
        XCTAssertTrue(interactorMock.deleteActivityCalled, "deleteActivity should have been called")
        XCTAssertTrue(viewMock.isReloadDataCalled, "reloadData should have been called after deleting an activity")
    }
    
}

class ActivitiesInteractorMock: ActivitiesInteractorProtocol {
    var activities: [ActivitiesModel] = [
        ActivitiesModel(tittle: "Study"),
        ActivitiesModel(tittle: "Work")
    ]
    
    var fetchActivitiesCalled = false
    var addActivityCalled = false
    var deleteActivityCalled = false
    
    func fetchActivities(completion: @escaping (Bool) -> Void) {
        fetchActivitiesCalled = true
        completion(true)
    }
    
    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void) {
        addActivityCalled = true
        activities.append(activity)
        completion(true)
    }
    
    func deleteActivity(at index: Int, completion: @escaping (Bool) -> Void) {
        deleteActivityCalled = true
        activities.remove(at: index)
        completion(true)
    }
    
    func validateActivityName(_ name: String) -> Bool {
        return !name.isEmpty
    }
}

class ActivitiesViewMock: ActivitiesViewProtocol {
    var isReloadDataCalled = false
    var activityShown: ActivitiesModel?
    
    func reloadData() {
        isReloadDataCalled = true
    }
    
    func showActivityDetail(_ activity: ActivitiesModel) {
        activityShown = activity
    }
}
