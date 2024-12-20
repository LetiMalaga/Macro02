//
//  ModalTagsFactory.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 05/11/24.
//

import Foundation
import UIKit

class ModalTagsFactory {
    static func makeModalTags(delegate:PassingTag) -> SheetViewController{
        let vc = SheetViewController()
        let interactor = ModalTagsInteractor()
        let presenter = ModalTagsPresenter()
        let data = ModalTagsData()
        
        presenter.view = vc
        vc.delegate = delegate
        interactor.presenter = presenter
        interactor.dataManager = data
        vc.interactor = interactor
        
        return vc
    }
}
