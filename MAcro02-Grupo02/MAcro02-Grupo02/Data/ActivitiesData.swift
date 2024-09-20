//
//  ActivitiesData.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 18/09/24.
//

import Foundation
protocol ActivitiesDataProtocol {
    
    func fetchActivities(completion: @escaping ([ActivitiesModel]) -> Void)
    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void)
    func deleteActivity(at index: UUID, completion: @escaping (Bool) -> Void)
}

struct ActivitiesModel {
    var id = UUID()
    var tittle: String
}

class ActivitiesData: ActivitiesDataProtocol {
    var teste = [ActivitiesModel(tittle: "Study"), ActivitiesModel(tittle: "Work"), ActivitiesModel(tittle: "Exercise")]
    
    func deleteActivity(at id: UUID, completion: @escaping (Bool) -> Void) {
        if let index = teste.firstIndex(where: { $0.id == id }) {
            teste.remove(at: index)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func fetchActivities(completion: @escaping ([ActivitiesModel]) -> Void) {
        completion(teste)
    }
    
    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void) {
        teste.append(activity)
        completion(true)
    }
    
}
