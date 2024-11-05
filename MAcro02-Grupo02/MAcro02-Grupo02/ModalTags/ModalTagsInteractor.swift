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
    
    func validateTag(_ tag: String, completion: @escaping (Bool) -> Void)
}

class ModalTagsInteractor: ModalTagsInteractorProtocol {
    var dataManager: ModalTagsDataProtocol?
    var presenter: ModalTagsPresenterProtocol?
    var tags : [String] = []
    
    init(){
        self.fetchTags()
    }
    
    func fetchTags() {
        dataManager?.fetchTags(completion: { tags in
            self.tags = tags
            self.presenter?.presentTags(tags)
        })
        
    }
    
    func deleteTag(_ tag: String) {
        dataManager?.deleteTag(at: tag){ tags in
            self.tags = tags
            self.presenter?.presentTags(self.tags)
        }
    }
    
    func addTag(_ tag: String) {
        self.validateTag(tag) { validate in
            if validate{
                self.dataManager?.addTag(tag){ tags in
                    self.tags = tags
                    self.presenter?.presentTags(tags)
                }
            }else {
                self.presenter?.ShowAlert("Error", "Tag already exists or is empty")
            }
        }
        
        
    }
    
    func validateTag(_ tag: String, completion: @escaping (Bool) -> Void) {
        dataManager?.fetchTags(){ tags in
            if (tags.contains(tag) || tag.isEmpty){
                completion(false)
            }else{
                completion(true)
            }
        }
    }
}
