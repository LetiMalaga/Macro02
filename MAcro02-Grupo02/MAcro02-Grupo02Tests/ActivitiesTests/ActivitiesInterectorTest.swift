//
//  ActivitiesInterectorTest.swift
//  MAcro02-Grupo02Tests
//
//  Created by Luiz Felipe on 18/09/24.
//

import XCTest
@testable import MAcro02_Grupo02

final class ActivitiesInteractorTest: XCTestCase {
    var interactor:ActivitiesInteractor!
    var mockActivitiesData:ActivitiesDataMock!
    
    override func setUp() {
        super.setUp()
        mockActivitiesData = ActivitiesDataMock()
        interactor = ActivitiesInteractor(activitiesData: mockActivitiesData)
    }
    
    func testFetchActivitiesSuccess() {
        let expectation = self.expectation(description: "fetchActivities")
        // Act
        interactor.fetchActivities { activities in
            // Assert
            XCTAssertEqual(activities, String(activities.))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func testAddActivitySuccess() {
        // Arrange
        let newActivity = ActivitiesModel(tittle: "Read a book")
        let expectation = self.expectation(description: "addActivity")
        
        // Act
        interactor.addActivity(newActivity) { success in
            // Assert
            XCTAssertTrue(success)
            XCTAssertTrue(self.mockActivitiesData.mockActivities.contains(where: newActivity))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    func testFetchActivitiesError() {
        // Arrange
        mockActivitiesData.shouldReturnError = true
        let expectation = self.expectation(description: "fetchActivitiesError")
        
        // Act
        interactor.fetchActivities { activities in
            // Assert
            XCTAssertTrue(activities.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    func testAddActivityError() {
        // Arrange
        mockActivitiesData.shouldReturnError = true
        let newActivity = ActivitiesModel(tittle:"Read a book")
        let expectation = self.expectation(description: "addActivityError")
        
        // Act
        interactor.addActivity(newActivity) { success in
            // Assert
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

class ActivitiesDataMock: ActivitiesDataProtocol {
    
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
        if shouldReturnError {
            completion(false)
        } else {
            mockActivities.append(activity)
            completion(true)
        }
    }
    
    
}
