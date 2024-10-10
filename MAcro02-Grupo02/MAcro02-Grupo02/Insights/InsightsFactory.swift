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
        
        var viewController = InsightsViewController()
        let presenter = InsightsPresenter(view: viewController)
        let interactor = InsightsInteractor(presenter: presenter)
        
        viewController.interactor = interactor
        
        return viewController
    }
}
