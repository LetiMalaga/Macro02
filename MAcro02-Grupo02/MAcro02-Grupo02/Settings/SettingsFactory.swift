//
//  SettingsFactory.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 01/11/24.
//

import Foundation
import UIKit

class SettingsFactory {
    static func makeSettings() -> UIViewController{
        
        let vc = SettingsViewController()
        let interactor = SettingsIteractor()
        let presenter = SettingsPresenter()
        let data = SettingsData()
        
        presenter.view = vc
        interactor.presenter = presenter
        interactor.dataModel = data
        vc.interactor = interactor
        
        return vc
        
    }
}
