//
//  ActivitiesPresenterTests.swift
//  MAcro02-Grupo02Tests
//
//  Created by Luiz Felipe on 23/09/24.
//

import XCTest

@testable import MAcro02_Grupo02


final class ActivitiesPresenterTests: XCTestCase {
    
    func tesViewDidLoad() {
        let mockActivities = ActivitiesDataMock()
        let interactor = ActivitiesInteractor(activitiesData: mockActivities)
        let presenter = ActivitiesPresenter(view: ActivitiesViewController() as! ActivitiesViewProtocol, activitiesInteractor: interactor)
        
        
    }
    
}

class ActivitiesInteractorMock: ActivitiesInteractorProtocol {
    var activities: [ActivitiesModel] = [ActivitiesModel(tittle: "Study"), ActivitiesModel(tittle: "Work"), ActivitiesModel(tittle: "Exercise")]
    var shouldReturnError = false
    
    func fetchActivities(completion: @escaping (Bool) -> Void) {
        if !shouldReturnError {
            completion(true)
        }else {
            completion(false)
        }
    }
    
    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void) {
        if validateActivityName(activity.tittle) {
            if shouldReturnError {
                completion(false)
            }else {
                completion(true)
            }
        }
    }
    
    func deleteActivity(at index: Int, completion: @escaping (Bool) -> Void) {
        if index < activities.count {
            let activity = activities[index]
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func validateActivityName(_ name: String) -> Bool {
        return !name.isEmpty
    }
    
    
}
