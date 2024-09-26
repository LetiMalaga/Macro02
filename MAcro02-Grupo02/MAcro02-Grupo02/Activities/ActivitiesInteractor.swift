//
//  ActivitiesInteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 18/09/24.
//

import Foundation

protocol ActivitiesInteractorProtocol:AnyObject{
    var activities:[ActivitiesModel] { get set }
    
    func fetchActivities(completion: @escaping (Bool) -> Void)
    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void)
    func deleteActivity(at index: Int, completion: @escaping (Bool) -> Void)
    func validateActivityName(_ name: String) -> Bool
}

//------------------------------------------------------------------------------------------------------

class ActivitiesInteractor: ActivitiesInteractorProtocol {
    
    var activities: [ActivitiesModel] = []
    private var activitiesData:ActivitiesDataProtocol
    
    init(activitiesData: ActivitiesDataProtocol) {
        self.activitiesData = activitiesData
    }
    
    func fetchActivities(completion: @escaping (Bool) -> Void) {
        activitiesData.fetchActivities { [weak self] activities in
            if !activities.isEmpty {
                self?.activities = activities
                completion(true)
            }else {
                completion(false)
            }
        }
        
    }
    
    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void) {
        if validateActivityName(activity.tittle) {
            activitiesData.addActivity(activity) { success in
                completion(success)
            }
        } 
    }
    
    func deleteActivity(at index: Int, completion: @escaping (Bool) -> Void) {
        if index < activities.count {
            let activity = activities[index]
            activitiesData.deleteActivity(at: activity.id) { success in
                completion(true)
                print ("Deleted activity: \(activity)")
            }
        } else {
            print ("Index out of bounds")
            completion(false)
        }
    }
    
    func validateActivityName(_ name: String) -> Bool {
        return !name.isEmpty
    }
}
