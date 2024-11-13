//
//  PomoDefaults.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 15/10/24.
//

import Foundation

enum locals {
    case home
    case outside
}

class PomoDefaults {
    
    private let defaults = UserDefaults.standard
    
    private let workKey = "workDuration"
    private let breakKey = "breakDuration"
    private let longBreakKey = "longBreakDuration"
    private let loopKey = "loopsQuantity"
    private let tagKey = "tagKey"
    private let isFirstLaunchKey = "isFirstLaunch"
    
    enum PomoTag: String {
        case work = "trabalho"
        case study = "estudo"
        case focus = "foco"
        case train = "treino"
    }
    
    var workDuration: Int {
        get {
            return defaults.integer(forKey: workKey)
        }
    }
    
    var breakDuration: Int {
        get {
            return defaults.integer(forKey: breakKey)
        }
    }
    
    var longBreakDuration: Int {
        get {
            return defaults.integer(forKey: longBreakKey)
        }
    }
    
    var loops: Int {
        get {
            return defaults.integer(forKey: loopKey)
        }
    }
    
    var tag: PomoTag? {
        get {
            if let tagString = defaults.string(forKey: tagKey) {
                return PomoTag(rawValue: tagString)
            } else {
                return .none
            }
        }
    }
    
    func setTime(for key: String, value: Any) {
        defaults.set(value, forKey: key)
    }
    
    
    init() {
        if defaults.bool(forKey: isFirstLaunchKey) == false {
            defaults.set(25, forKey: workKey)
            defaults.set(5, forKey: breakKey)
            defaults.set(20, forKey: longBreakKey)
            defaults.set(PomoTag.work.rawValue, forKey: tagKey)
            defaults.set(4, forKey: loopKey)
            defaults.set(true, forKey: isFirstLaunchKey)
        }
    }
    
}
