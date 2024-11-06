//
//  ModalTagsInteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 05/11/24.
//

import Foundation
import UIKit

protocol ModalTagsInteractorProtocol: AnyObject {
    var dataManager: ModalTagsDataProtocol? { get }
    
    func fetchTags()
    func deleteTag(_ tag: String)
    func addTag(_ tag: String)
    
    func validateTag(_ tag: String) -> Bool
}

class ModalTagsInteractor: ModalTagsInteractorProtocol {
    var dataManager: ModalTagsDataProtocol?
    var presenter: ModalTagsPresenterProtocol?
    var tags : [String] = []
    
    func fetchTags() {
        dataManager?.fetchTags(completion: { tags in
            self.tags = tags
            self.presenter?.presentTags(tags)
        })
        
    }
    
    func deleteTag(_ tag: String) {
        dataManager?.deleteTag(at: tag){ tags in
            if let index = self.tags.firstIndex(where: { $0 == tag }){
                self.tags = tags
                self.presenter?.removeTag(index, self.tags)
            }
        }
    }
    
    func addTag(_ tag: String) {
        if validateTag(tag){
            dataManager?.addTag(tag){tags in
                self.tags = tags
                self.presenter?.presentTags(tags)
            }
        }else {
            presenter?.ShowAlert("Error", "Tag already exists or is empty")
        }
    }
    
    func validateTag(_ tag: String) -> Bool {
        if tags.contains(tag) || tag.isEmpty{
            return false
        }else{
            return true
        }
    }
}
