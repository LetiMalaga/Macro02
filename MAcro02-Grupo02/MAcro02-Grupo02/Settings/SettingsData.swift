//
//  SettingsData.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 30/10/24.
//
import Foundation
enum ActivitiesType: String, Codable {
    case long
    case short
}
struct ActivitiesModel: Codable {
    var id = UUID()
    var type: ActivitiesType
    var description: String
    var tag:String
    
}
protocol SettingsDataProtocol {
    func fetchActivities(completion: @escaping ([ActivitiesModel]) -> Void)
    func fetchTags(completion: @escaping ([String]) -> Void) 
    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void)
    func deleteActivity(at id: UUID, completion: @escaping (Bool) -> Void)
}

class SettingsData: SettingsDataProtocol{
    private let userDefaultsKey = "activitiesData"
    private let userDefaultsKeyTags = "tagsData"
    
    func fetchActivities(completion: @escaping ([ActivitiesModel]) -> Void) {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           var decodedActivities = try? JSONDecoder().decode([ActivitiesModel].self, from: savedData) {
            decodedActivities.removeLast()
            completion(decodedActivities)
        } else {
            completion([])
        }
    }
    func fetchTags(completion: @escaping ([String]) -> Void) {
        guard let savedData = UserDefaults.standard.stringArray(forKey: userDefaultsKeyTags) else {return}
        completion(savedData)
    }
    
    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void) {
        fetchActivities { activities in
            var updatedActivities = activities
            updatedActivities.append(activity)
            
            if let encodedData = try? JSONEncoder().encode(updatedActivities) {
                UserDefaults.standard.set(encodedData, forKey: self.userDefaultsKey)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // Delete an activity by its UUID and update UserDefaults
    func deleteActivity(at id: UUID, completion: @escaping (Bool) -> Void) {
        fetchActivities { activities in
            if let index = activities.firstIndex(where: { $0.id == id }) {
                var updatedActivities = activities
                updatedActivities.remove(at: index)
                
                if let encodedData = try? JSONEncoder().encode(updatedActivities) {
                    UserDefaults.standard.set(encodedData, forKey: self.userDefaultsKey)
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
}
