////
////  ActivitiesInterectorTest.swift
////  MAcro02-Grupo02Tests
////
////  Created by Luiz Felipe on 18/09/24.
////
//
//import XCTest
//@testable import MAcro02_Grupo02
//
//final class ActivitiesInteractorTest: XCTestCase {
//    
//    func testFetchActivitiesSuccess() {
//        let mockActivitiesData = ActivitiesDataMock()
//        let mockActivitiesPresenter: ActivitiesPresenterProtocol = ActivitiesPresenterMock()
//        let interactor = ActivitiesInteractor()
//        
//        let expectation = self.expectation(description: "fetchActivities")
//        
//        interactor.fetchActivities()
//        XCTAssertFalse(interactor.activities.isEmpty)
//        expectation.fulfill()
//        
//        wait(for: [expectation], timeout: 1.0)
//        
//    }
//    
//    func testAddActivitie() {
//        let mockActivitiesData = ActivitiesDataMock()
//        let mockActivitiesPresenter: ActivitiesPresenterProtocol = ActivitiesPresenterMock()
//        let interactor = ActivitiesInteractor()
//        
//        let expectation = self.expectation(description: "addActivities")
//        
//        let activity = ActivitiesModel(tittle: "Study")
//        interactor.addActivity(activity) { success in
//            XCTAssertTrue(success)
//        }
//        XCTAssertFalse(interactor.activities.contains(where: { activity in
//            activity.tittle == activity.tittle
//        }))
//        
//        expectation.fulfill()
//        
//        wait(for: [expectation], timeout: 1.0)
//    }
//    
//    func testDeleteActivity() {
//        let mockActivitiesData = ActivitiesDataMock()
//        let mockActivitiesPresenter: ActivitiesPresenterProtocol = ActivitiesPresenterMock()
//        let interactor = ActivitiesInteractor(activitiesData: mockActivitiesData, presenter: mockActivitiesPresenter)
//        
//        let expectation = self.expectation(description: "deleteActivity")
//        
//        let activity = ActivitiesModel(tittle: "Teste")
//        interactor.addActivity(activity) { success in
//            XCTAssertTrue(success)
//        }
//        
//        if let index = interactor.activities.firstIndex(where: { $0.tittle == "Teste"}){
//            XCTAssertTrue(index < interactor.activities.count)
//            interactor.deleteActivity(at: index)
//            XCTAssertFalse(interactor.activities.contains(where: {$0.tittle == "Teste"}))
//        }
//        
//        expectation.fulfill()
//        
//        wait(for: [expectation], timeout: 1.0)
//        
//    }
//    
//    func testValidateActivityName() {
//        let mockActivitiesData = ActivitiesDataMock()
//        let mockActivitiesPresenter: ActivitiesPresenterProtocol = ActivitiesPresenterMock()
//        let interactor = ActivitiesInteractor(activitiesData: mockActivitiesData, presenter: mockActivitiesPresenter)
//        
//        let expectation = self.expectation(description: "validateActivityName")
//        
//        let name = "Study"
//        XCTAssertTrue(interactor.validateActivityName(name))
//        expectation.fulfill()
//        
//        wait(for: [expectation], timeout: 1.0)
//    }
//}
//
//class ActivitiesDataMock: ActivitiesDataProtocol {
//    
//    var mockActivities = [ActivitiesModel(tittle: "Study"), ActivitiesModel(tittle: "Work"), ActivitiesModel(tittle: "Exercise")]
//    var shouldReturnError = false
//    
//    func fetchActivities(completion: @escaping ([ActivitiesModel]) -> Void) {
//        if shouldReturnError {
//            completion([])
//        } else {
//            completion(mockActivities)
//        }
//    }
//    
//    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void) {
//        if !shouldReturnError{
//            mockActivities.append(activity)
//            completion(true)
//        } else {
//            completion(false)
//        }
//    }
//    
//    func deleteActivity(at id: UUID, completion: @escaping (Bool) -> Void) {
//        if let index = mockActivities.firstIndex(where: { $0.id == id }) {
//            if shouldReturnError {
//                completion(false)
//            }else{
//                mockActivities.remove(at: index)
//                completion(true)
//            }
//        } else {
//            completion(false)
//        }
//    }
//    
//}
//    class ActivitiesPresenterMock: ActivitiesPresenterProtocol {
//        
//        
//        func uploadActivitys(_ activity: [ActivitiesModel]) {
//
//        }
//        
//        func returnActivity(activity: ActivitiesModel) {
//        }
//        
//        func deleteActivity(at index: Int) {
//
//        }
//        
//    }
