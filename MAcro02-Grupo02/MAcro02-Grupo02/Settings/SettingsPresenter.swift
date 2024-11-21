//
//  SettingsPresenter.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 30/10/24.
//

import Foundation

protocol SettingsPresenterProtocol: AnyObject {
    func uploadActivitys(_ activity: [ActivitiesModel])
    func uploadTags(_ tags:[String])
    func addActivity(_ activity: ActivitiesModel)
    func returnActivity(activity: ActivitiesModel)
    func deleteActivity(at id: UUID)
    func toggleButtonSound(value: Bool)
    func toggleButtonVibration(value: Bool)
    func toggleButtonBreathing(value: Bool)
    func toggleButtonRecomendation(value: Bool)
    func toggleButtonDefaultActivities(value: Bool)
}

class SettingsPresenter: SettingsPresenterProtocol {
    var view : SettingsViewProtocol?
    
    func uploadActivitys(_ activity: [ActivitiesModel]) {
        view?.activities = activity
        view?.reloadData()
    }
    func uploadTags(_ tags:[String]){
        view?.tags = tags
        view?.reloadData()

    }
    func addActivity(_ activity: ActivitiesModel) {
        view?.activities.append(activity)
        view?.reloadData()

    }
    
    func returnActivity(activity: ActivitiesModel) {
        print(activity)
    }
    
    func deleteActivity(at id: UUID) {
        view?.activities.removeAll(where: { $0.id == id })
        view?.reloadData()

    }
    
    func toggleButtonSound(value: Bool) {
        view?.soundButton = value
    }
    
    func toggleButtonVibration(value: Bool) {
        view?.vibrationButton = value
    }
    
    func toggleButtonBreathing(value: Bool) {
        view?.breathingButton = value
    }
    
    func toggleButtonRecomendation(value: Bool) {
        view?.recommendationButton = value
    }
    
    func toggleButtonDefaultActivities(value: Bool) {
        view?.defaultActivitiesButton = value
    }
    
}

protocol SettingsViewProtocol: AnyObject {
    var soundButton: Bool { get set }
    var vibrationButton: Bool { get set }
    var breathingButton: Bool { get set }
    var recommendationButton: Bool { get set }
    var defaultActivitiesButton: Bool { get set }
    var activities: [ActivitiesModel] { get set }
    var tags:[String] { get set }
    
    
    func reloadData()
}
