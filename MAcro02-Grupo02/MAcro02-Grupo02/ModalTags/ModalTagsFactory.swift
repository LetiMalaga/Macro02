//
//  ModalTagsFactory.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 05/11/24.
//

import Foundation
import UIKit

class ModalTagsFactory {
    static func makeModalTags() -> UIViewController{
        var vc = SheetViewController()
        var interactor = ModalTagsInteractor()
        var presenter = ModalTagsPresenter()
        let data = ModalTagsData()
        
        presenter.view = vc
        interactor.presenter = presenter
        interactor.dataManager = data
        vc.interactor = interactor
        
        return vc
    }
}
