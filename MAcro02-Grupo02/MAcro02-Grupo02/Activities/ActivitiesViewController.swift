//
//  ActivitiesViewController.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 17/09/24.
//

import UIKit

class ActivitiesView: UIViewController
{
    
    var ActivityScreen: ActivitiesScreen?
    
    override func loadView() {
        ActivityScreen = ActivitiesScreen()
        view = ActivityScreen
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func saveTasks() {}
    @objc func deleteTasks() {}
}
