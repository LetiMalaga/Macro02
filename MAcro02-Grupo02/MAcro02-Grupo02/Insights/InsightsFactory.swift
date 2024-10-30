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

//        let data = InsightsData()
        let presenter = InsightsPresenter()
        let interactor = InsightsInteractor()
        let viewController = InsightsSwiftUIViewController(interactor: interactor)

        presenter.view = viewController
//        interactor.dataManager = data
        interactor.presenter = presenter
//        viewController.interactor = interactor
        
        return viewController
    }
}
