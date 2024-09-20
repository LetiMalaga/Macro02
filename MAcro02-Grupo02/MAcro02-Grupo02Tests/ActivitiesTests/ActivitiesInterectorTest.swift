//
//  ActivitiesInterectorTest.swift
//  MAcro02-Grupo02Tests
//
//  Created by Luiz Felipe on 18/09/24.
//

import XCTest
@testable import MAcro02_Grupo02

final class ActivitiesInteractorTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testFetchActivitiesSuccess() {
        let mockActivitiesData = ActivitiesDataMock()
        let interactor = ActivitiesInteractor(activitiesData: mockActivitiesData)
        
        let expectation = self.expectation(description: "fetchActivities")
        
        // Act
        interactor.fetchActivities { success in
            
            // Assert
            XCTAssertTrue(success)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func testAddActivitySuccess() {
        let mockActivitiesData = ActivitiesDataMock()
        let interactor = ActivitiesInteractor(activitiesData: mockActivitiesData)
        
        // Arrange
        let newActivity = ActivitiesModel(tittle: "Read a book")
        let expectation = self.expectation(description: "addActivity")
        
        // Act
        interactor.addActivity(newActivity) { success in
            // Assert
            XCTAssertTrue(success)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDeleteActivitySuccess() {
        let mockActivitiesData = ActivitiesDataMock()
        let interactor = ActivitiesInteractor(activitiesData: mockActivitiesData)
        
        let expectation = self.expectation(description: "deleteActivity")
        
        interactor.deleteActivity(at: 0) { success in
            XCTAssertTrue(!success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
    }
    func testFetchActivitiesError() {
        let mockActivitiesData = ActivitiesDataMock()
        let interactor = ActivitiesInteractor(activitiesData: mockActivitiesData)
        
        // Arrange
        mockActivitiesData.shouldReturnError = true
        let expectation = self.expectation(description: "fetchActivitiesError")
        
        // Act
        interactor.fetchActivities { success in
            // Assert
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    func testAddActivityError() {
        let mockActivitiesData = ActivitiesDataMock()
        let interactor = ActivitiesInteractor(activitiesData: mockActivitiesData)
        
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
    
    func testDeleteActivityError() {
        let mockActivitiesData = ActivitiesDataMock()
        let interactor = ActivitiesInteractor(activitiesData: mockActivitiesData)
        
        mockActivitiesData.shouldReturnError = true
        
        let expectation = self.expectation(description: "deleteActivityError")
        
        interactor.deleteActivity(at: 0) { success in
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
