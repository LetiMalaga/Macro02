//
//  ActivitiesPresenter.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 18/09/24.
//

import Foundation

protocol ActivitiesPresenterProtocol: AnyObject {
    var activities : [ActivitiesModel] { get set }
    func viewDidLoad()
    func getActivity(at index: Int) -> ActivitiesModel
    func didSelectActivity(at index: Int)
    func deleteActivity(at index: Int)
    func addNewActivity(_ activity: ActivitiesModel)
}

//------------------------------------------------------------------------------------------------------

class ActivitiesPresenter: ActivitiesPresenterProtocol {
    private var view: ActivitiesViewProtocol!
    private var interactor: ActivitiesInteractorProtocol
    
    internal var activities: [ActivitiesModel] = []
    
    init (view: ActivitiesViewProtocol, activitiesInteractor: ActivitiesInteractorProtocol) {
        self.view = view
        self.interactor = activitiesInteractor
    }
    
    func viewDidLoad() {
        fetchActivities()
    }
    
    func fetchActivities() {
        interactor.fetchActivities { success in
            if success{
                self.activities = self.interactor.activities
                self.view?.reloadData()
            }
        }
    }
    
    func getActivity(at index: Int) -> ActivitiesModel {
        return activities[index]
    }
    
    func didSelectActivity(at index: Int) {
        let activities = getActivity(at: index)
        view?.showActivityDetail(activities)
    }
    
    func addNewActivity(_ activity: ActivitiesModel) {
        interactor.addActivity(activity) { [weak self] success in
            if success {
                self?.view?.reloadData()
            }
        }
    }
    
    func deleteActivity(at index: Int) {
        interactor.deleteActivity(at: index) { [weak self] success in
            if success {
                self?.view?.reloadData()
            }
        }
    }
    
}
