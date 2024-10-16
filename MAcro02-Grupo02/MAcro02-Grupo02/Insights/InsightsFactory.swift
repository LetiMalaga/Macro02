//
//  InsightsFactory.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 07/10/24.
//

import Foundation
import UIKit

class InsightsFactory {
    static func makeInsights() -> UIViewController {

        let viewController = InsightsViewController()
        let data = InsightsData()
        let presenter = InsightsPresenter(view: viewController)
        let interactor = InsightsInteractor(presenter: presenter, dataManager: data)
        
        viewController.interactor = interactor
        
        return viewController
    }
}
