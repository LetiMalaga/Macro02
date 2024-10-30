//
//  SettingsPresenter.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 30/10/24.
//

import Foundation

protocol SettingsPresenterProtocol: AnyObject {
    func uploadActivitys(_ activity: [ActivitiesModel])
    func addActivity(_ activity: ActivitiesModel)
    func returnActivity(activity: ActivitiesModel)
    func deleteActivity(at index: Int)
    func toggleButtonSound(value: Bool)
    func toggleButtonVibration(value: Bool)
    func toggleButtonBreathing(value: Bool)
    func toggleButtonRecomendation(value: Bool)
}

class SettingsPresenter: SettingsPresenterProtocol {
    var view : SettingsViewProtocol?
    
    func uploadActivitys(_ activity: [ActivitiesModel]) {
        view?.activitys = activity
    }
    
    func addActivity(_ activity: ActivitiesModel) {
        view?.activitys.append(activity)
    }
    
    func returnActivity(activity: ActivitiesModel) {
        <#code#>
    }
    
    func deleteActivity(at index: Int) {
        view?.activitys.remove(at: index)
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
    
}

protocol SettingsViewProtocol: AnyObject {
    var soundButton: Bool { get set }
    var vibrationButton: Bool { get set }
    var breathingButton: Bool { get set }
    var recommendationButton: Bool { get set }
    var activitys: [ActivitiesModel] { get set }
}
