////
////  ActivitiesPresenter.swift
////  MAcro02-Grupo02
////
////  Created by Luiz Felipe on 18/09/24.
////
//
//import Foundation
//
//protocol ActivitiesPresenterProtocol: AnyObject {
//    func uploadActivitys(_ activity: [ActivitiesModel])
//    func returnActivity(activity: ActivitiesModel)
//    func deleteActivity(at index: Int)
//}
//
////------------------------------------------------------------------------------------------------------
//
//class ActivitiesPresenter: ActivitiesPresenterProtocol {
//    private var view: ActivitiesViewProtocol!
//    
//    init (view: ActivitiesViewProtocol) {
//        self.view = view
//    }
//    
//    func uploadActivitys(_ activity: [ActivitiesModel]) {
//        view.activities = activity
//        view.reloadData()
//    }
//    
//    func returnActivity(activity: ActivitiesModel) {
//        view.selectededActivity = activity
//    }
//    
//    func deleteActivity(at index: Int) {
//        view.activities.remove(at: index)
//        view.reloadData()
//    }
//    
//}
