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
    
    func fetchActivities(isCSV: Bool)
    func fetchTags()
    func addActivity(_ activity: ActivitiesModel)
    func deleteActivity(at activityID: UUID)
    func updateActivity(_ activity: ActivitiesModel)
    func loadActivitiesFromCSV()
    func validateActivityName(_ activity: ActivitiesModel,_ action: ActionForActivity) -> Bool
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
    
    func fetchActivities(isCSV: Bool) {
        let activities = dataModel?.fetchActivities() ?? []

        let filteredActivities = activities.filter { !$0.isCSV } // Fetch only non-CSV activities

        self.activities = filteredActivities.map {
            ActivitiesModel(
                id: $0.id,
                type: ActivitiesType(rawValue: $0.type) ?? .short,
                description: $0.descriptionText,
                tag: $0.tag,
                isCSV: $0.isCSV
            )
        }

        self.presenter?.uploadActivitys(self.activities)
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
    func updateActivity(_ activity: ActivitiesModel){
        dataModel?.editActivity(at: activity.id, with: activity, completion: { success in
            if success{
                self.activities[self.activities.firstIndex(where: {$0.id == activity.id})!] = activity
                self.presenter?.uploadActivitys(self.activities)
            }else{
                print("Error updating activity: \(activity)")
            }
        })
    }
    
    func loadActivitiesFromCSV() {
        print("🔄 Starting to load activities from CSV...")
        let shortActivities = CSVParser.parseCSV(from: "Atividades_Curtas_Simples")
        let longActivities = CSVParser.parseCSV(from: "Atividades_Longas_Simples")
        let allActivities = shortActivities + longActivities
        
        print("✅ Found \(allActivities.count) activities in total.")
        
        for activity in allActivities {
            if !activities.contains(where: { $0.description == activity.description }) {
                print("➕ Adding activity: \(activity.description)")
                addActivity(activity)
            } else {
                print("⏩ Skipping already existing activity: \(activity.description)")
            }
        }
    }
    
    func validateActivityName(_ activity: ActivitiesModel, _ action: ActionForActivity) -> Bool {
        switch action {
        case .adding:
            if (!activity.description.isEmpty && !activities.contains(where: { $0.description == activity.description })){
                return true
            }else{
                return false
            }
        case .edit:
            if (!activity.description.isEmpty && (!activities.contains(where: { $0.description == activity.description && $0.tag == activity.tag} ))){
                return true
            }else{
                return false
            }
        }
    }
    
}

enum ActionForActivity{
    case edit
    case adding
}
