//
//  SettingsIteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 30/10/24.
//

import Foundation

protocol SettingsIteractorProtocol: AnyObject {
    var activities: [ActivitiesModel] {get set}
    var presenter: SettingsPresenterProtocol? {get}
    
    
    func changeSound()
    func changeVibration()
    func changeBreathing()
    func changeRecomendations()
    
    func fetchActivities()
    func fetchTags(completion: @escaping (Bool) -> Void)
    func addActivity(_ activity: ActivitiesModel)
    func deleteActivity(at index: Int)
    func getActivity(at index: Int)
    func validateActivityName(_ name: String) -> Bool
}

class SettingsIteractor: SettingsIteractorProtocol {
    
    var activities: [ActivitiesModel] = []
    var presenter: SettingsPresenterProtocol?
    var dataModel: SettingsDataProtocol?
    
    func changeSound() {
        var sound = UserDefaults.standard.bool(forKey: "sound")
        sound.toggle()
        presenter?.toggleButtonSound(value: sound)
        UserDefaults.standard.set(sound, forKey: "sound")
    }
    
    func changeVibration() {
        var vibration = UserDefaults.standard.bool(forKey: "vibration")
        vibration.toggle()
        presenter?.toggleButtonVibration(value: vibration)
        UserDefaults.standard.set(vibration, forKey: "vibration")
    }
    
    func changeBreathing() {
        var breathing = UserDefaults.standard.bool(forKey: "breathing")
        breathing.toggle()
        presenter?.toggleButtonBreathing(value: breathing)
        UserDefaults.standard.set(breathing, forKey: "breathing")
    }
    
    func changeRecomendations() {
        var recomendations = UserDefaults.standard.bool(forKey: "recomendations")
        recomendations.toggle()
        presenter?.toggleButtonRecomendation(value: recomendations)
        UserDefaults.standard.set(recomendations, forKey: "recomendations")
    }
    
    func fetchActivities() {
        dataModel?.fetchActivities { [weak self] activities in
            if !activities.isEmpty {
                self?.activities = activities
                self?.presenter?.uploadActivitys(activities)
            }
        }
    }
    
    func fetchTags(completion: @escaping (Bool) -> Void){
        dataModel?.fetchTags(completion: { [weak self] tags in
            if tags.isEmpty{
                print("no tags in memory")
                completion(false)
            }else{
                self?.presenter?.uploadTags(tags)
                completion(true)
            }
        })
    }
    
    func addActivity(_ activity: ActivitiesModel) {
        if validateActivityName(activity.description) {
            dataModel?.addActivity(activity) { success in
                self.presenter?.addActivity(activity)
            }
        }
    }
    
    func deleteActivity(at index: Int) {
        if index < activities.count {
            let activity = activities[index]
            dataModel?.deleteActivity(at: activity.id) { success in
                print ("Deleted activity: \(activity)")
            }
            presenter?.deleteActivity(at: index)
        } else {
            print ("Index out of bounds")
        }
    }
    
    func getActivity(at index: Int){
        presenter?.returnActivity(activity: self.activities[index])
    }
    
    func validateActivityName(_ name: String) -> Bool {
        return !name.isEmpty
    }
    
}
