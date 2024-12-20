////
////  ActivitiesInteractor.swift
////  MAcro02-Grupo02
////
////  Created by Luiz Felipe on 18/09/24.
////
//
//import Foundation
//
//protocol ActivitiesInteractorProtocol:AnyObject{
//    var activities:[ActivitiesModel] { get set }
//    
//    func fetchActivities()
//    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void)
//    func deleteActivity(at index: Int)
//    func getActivity(at index: Int)
//    func validateActivityName(_ name: String) -> Bool
//}
//
////------------------------------------------------------------------------------------------------------
//
//class ActivitiesInteractor: ActivitiesInteractorProtocol {
//    
//    var activities: [ActivitiesModel] = []
//    private var activitiesData:ActivitiesDataProtocol
//    private var presenter:ActivitiesPresenterProtocol
//    
//    init (activitiesData:ActivitiesDataProtocol, presenter:ActivitiesPresenterProtocol) {
//        self.activitiesData = activitiesData
//        self.presenter = presenter
//    }
//    
//    func fetchActivities() {
//        activitiesData.fetchActivities { [weak self] activities in
//            if !activities.isEmpty {
//                self?.activities = activities
//                self?.presenter.uploadActivitys(activities)
//            }
//        }
//        
//    }
//    
//    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void) {
//        if validateActivityName(activity.tittle) {
//            activitiesData.addActivity(activity) { success in
//                completion(success)
//            }
//        } 
//    }
//    
//    func deleteActivity(at index: Int) {
//        if index < activities.count {
//            let activity = activities[index]
//            activitiesData.deleteActivity(at: activity.id) { success in
//                print ("Deleted activity: \(activity)")
//            }
//            presenter.deleteActivity(at: index)
//        } else {
//            print ("Index out of bounds")
//        }
//    }
//    
//    func getActivity(at index: Int){
//        presenter.returnActivity(activity: self.activities[index])
//    }
//    
//    func validateActivityName(_ name: String) -> Bool {
//        return !name.isEmpty
//    }
//}
