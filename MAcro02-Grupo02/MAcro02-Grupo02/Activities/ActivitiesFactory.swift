//
//  ActivitiesFactory.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 23/09/24.
//

import Foundation
import UIKit

class ActivitiesFactory{
    static func makeActivitiesModule() -> UIViewController {
        let viewController = ActivitiesViewController()
        let data = ActivitiesData()
        let interactor = ActivitiesInteractor(activitiesData: data)
        let presenter = ActivitiesPresenter(view: viewController, activitiesInteractor: interactor)
        viewController.presenter = presenter
        return viewController
    }
}
