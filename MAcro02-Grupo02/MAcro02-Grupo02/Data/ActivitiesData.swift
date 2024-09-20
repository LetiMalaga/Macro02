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
}

struct ActivitiesModel {
    var tittle: String
}
