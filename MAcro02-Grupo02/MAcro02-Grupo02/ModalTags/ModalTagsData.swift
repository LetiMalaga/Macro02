//
//  ModalTagsData.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 05/11/24.
//

import Foundation

protocol ModalTagsDataProtocol {
    func fetchTags(completion: @escaping ([String]) -> Void)
    func addTag(_ tag: String, completion: @escaping ([String]) -> Void)
    func deleteTag(at tag: String, completion: @escaping ([String]) -> Void)
}

class ModalTagsData: ModalTagsDataProtocol {
    private let userDefaultsKey = "tagsData"
    
    func fetchTags(completion: @escaping ([String]) -> Void) {
        if let savedData = UserDefaults.standard.stringArray(forKey: userDefaultsKey){
            completion(savedData)
        }else{
            let tags = ["Trabalho", "Estudo", "Foco", "Treino", "Meditação"]
            completion(tags)
        }
    }
    
    func addTag(_ tag: String, completion: @escaping ([String]) -> Void) {
        self.fetchTags { tags in
            var tagsWithNewTag = tags
            tagsWithNewTag.append(tag)
            completion(tagsWithNewTag)
            UserDefaults.standard.set(tagsWithNewTag, forKey: self.userDefaultsKey)
        }
    }
    
    func deleteTag(at tag: String, completion: @escaping ([String]) -> Void) {
        fetchTags { tags in
            if let index = tags.firstIndex(where: { $0 == tag }) {
                var tagsWithoutDeletedTag = tags
                tagsWithoutDeletedTag.remove(at: index)
                UserDefaults.standard.set(tagsWithoutDeletedTag, forKey: self.userDefaultsKey)
                completion(tagsWithoutDeletedTag)
            }else{
                completion(tags)
                print("Tag not found")
            }
        }
    }
}
