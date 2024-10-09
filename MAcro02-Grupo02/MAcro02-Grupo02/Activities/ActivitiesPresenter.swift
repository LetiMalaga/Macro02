//
//  ActivitiesPresenter.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 18/09/24.
//

import Foundation

protocol ActivitiesPresenterProtocol: AnyObject {
    var activities : [ActivitiesModel] { get set }
    func uploadActivitys(_ activity: [ActivitiesModel])
    func returnActivity(activity: ActivitiesModel?)
    func didSelectActivity(at index: Int)
    func deleteActivity(at index: Int)
    func addNewActivity(_ activity: ActivitiesModel)
}

//------------------------------------------------------------------------------------------------------

class ActivitiesPresenter: ActivitiesPresenterProtocol {
    private var view: ActivitiesViewProtocol!
    internal var activities: [ActivitiesModel] = []
    
    init (view: ActivitiesViewProtocol) {
        self.view = view
    }
    
    func uploadActivitys(_ activity: [ActivitiesModel]) {
        view.activities = activity
        view.reloadData()
    }
    
    func returnActivity(activity: ActivitiesModel) {
        view.selectededActivity = activity
    }
    
//    func addNewActivity(_ activity: ActivitiesModel) {
//        interactor.addActivity(activity) { [weak self] success in
//            if success {
//                self?.view?.reloadData()
//            }
//        }
//    }
    
    func deleteActivity(at index: Int) {
        interactor.deleteActivity(at: index) { [weak self] success in
            if success {
                self?.view?.reloadData()
            }
        }
    }
    
}
