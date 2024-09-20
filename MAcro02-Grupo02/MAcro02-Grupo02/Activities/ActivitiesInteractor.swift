//
//  ActivitiesInteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 18/09/24.
//

import Foundation

protocol ActivitiesInteractorProtocol:AnyObject{
    var activities:[ActivitiesModel] { get set }
    
    func fetchActivities(completion: @escaping ([ActivitiesModel]) -> Void)
    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void)
    func deleteActivity(at index: Int, completion: @escaping (Bool) -> Void)
    func validateActivityName(_ name: String) -> Bool
}

class ActivitiesInteractor: ActivitiesInteractorProtocol {
    var activities: [ActivitiesModel] = []
    private var activitiesData:ActivitiesDataProtocol
    
    init(activitiesData: ActivitiesDataProtocol) {
        self.activitiesData = activitiesData
    }
    
    func fetchActivities(completion: @escaping ([ActivitiesModel]) -> Void) {
        completion(activities)
    }
    
    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void) {
        if validateActivityName(activity.tittle) {
            activities.append(activity)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func deleteActivity(at index: Int, completion: @escaping (Bool) -> Void) {
        if index < activities.count {
            activities.remove(at: index)
            completion(true)
        } else {
            completion(false)
        }
    }
    func validateActivityName(_ name: String) -> Bool {
        return !name.isEmpty
    }
}
