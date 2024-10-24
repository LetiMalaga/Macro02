//
//  PomodoroBuilder.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import UIKit

class PomodoroRouter {
    func build() -> UIViewController {
        let viewController = PomodoroViewController()
        let presenter = PomodoroPresenter()
        let interactor = PomodoroInteractor()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
