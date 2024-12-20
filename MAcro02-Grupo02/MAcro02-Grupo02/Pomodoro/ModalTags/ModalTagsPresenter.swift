//
//  ModelTagsPresenter.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 05/11/24.
//

import Foundation

protocol ModalTagsPresenterProtocol: AnyObject {
    func presentTags(_ tags: [String])
    func showAlert(_ title: String, _ message: String)
}
class ModalTagsPresenter: ModalTagsPresenterProtocol {
    var view: SheetViewControllerProtocol?
    
    func presentTags(_ tags: [String]) {
        view?.tags = tags
    }
    
    func showAlert(_ title: String, _ message: String) {
        view?.showAlert(with: title, message: message)
    }
    
}
