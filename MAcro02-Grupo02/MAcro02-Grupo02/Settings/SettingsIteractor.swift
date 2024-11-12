//
//  SettingsIteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 30/10/24.
//

import Foundation

protocol SettingsIteractorProtocol: AnyObject {
    //    var activities: [ActivitiesModel] {get set}
    var presenter: SettingsPresenterProtocol? {get}
    
    
    func changeSound()
    func changeVibration()
    func changeBreathing()
    func changeRecomendations()
    
    func fetchActivities()
    func fetchTags()
    func addActivity(_ activity: ActivitiesModel)
    func deleteActivity(at activityID: UUID)
    func validateActivityName(_ name: String) -> Bool
}

class SettingsIteractor: SettingsIteractorProtocol {
    var activities: [ActivitiesModel] = []
    var presenter: SettingsPresenterProtocol?
    var dataModel: SettingsDataProtocol?
    //    init(){
    //        self.fetchActivities()
    //    }
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
    
    func fetchActivities(){
        
        let activities = dataModel?.fetchActivities()
        
        var activitiesModel: [ActivitiesModel] = []
        
        guard let activities else { return }
        
        for activity in activities {
            activitiesModel.append(ActivitiesModel(id: activity.id,
                                                   type: ActivitiesType(rawValue: activity.type) ?? .short,
                                                   description: activity.descriptionText,
                                                   tag: activity.tag))
        }
        self.activities = activitiesModel
        self.presenter?.uploadActivitys(activitiesModel)
    }
    
    func fetchTags(){
        dataModel?.fetchTags(completion: { [weak self] tags in
            if tags.isEmpty{
                print("no tags in memory")
            }else{
                self?.presenter?.uploadTags(tags)
            }
        })
    }
    
    func addActivity(_ activity: ActivitiesModel) {
        dataModel?.addActivity(activity) { success in
            self.presenter?.addActivity(activity)
            print("Added activity: \(activity)")
            self.activities.append(activity)
        }
    }
    
    func deleteActivity(at activityID: UUID) {
        dataModel?.deleteActivity(at: activityID) { success in
            print ("Deleted activity: \(activityID)")
        }
        presenter?.deleteActivity(at: activityID)
        self.activities.removeAll(where: { $0.id == activityID })
        
    }
    
    
    
    func validateActivityName(_ name: String) -> Bool {
        if (!name.isEmpty && !activities.contains(where: { $0.description == name })){
            return true
        }else{
            return false
        }
    }
    
}
