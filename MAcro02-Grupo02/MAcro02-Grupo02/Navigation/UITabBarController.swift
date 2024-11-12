//
//  UITabBarController.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 21/10/24.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        // Create the Pomodoro View Controller
        let pomodoroVC = PomodoroRouter().build()
        let pomodoroNavController = UINavigationController(rootViewController: pomodoroVC)
        pomodoroNavController.tabBarItem = UITabBarItem(title: "Pomodoro", image: UIImage(systemName: "timer"), tag: 0)
        
        // Create the Activities View Controller
//        let activitiesVC = ActivitiesViewController()
//        let activitiesNavController = UINavigationController(rootViewController: activitiesVC)
//        activitiesNavController.tabBarItem = UITabBarItem(title: "Activities", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        let insightsVC = InsightsFactory.makeInsights()
        let insightsNavController = UINavigationController(rootViewController: insightsVC)
        insightsNavController.tabBarItem = UITabBarItem(title: "Insights", image: UIImage(systemName: "chart.bar"), tag: 2)
        
        let settingsVC = SettingsFactory.makeSettings()
        
        let settingsNavController = UINavigationController(rootViewController: settingsVC)
        settingsNavController.tabBarItem = UITabBarItem(title: NSLocalizedString("Ajustes", comment: "Settings"), image: UIImage(systemName: "gearshape"), tag: 3)
        
        // Add the view controllers to the tab bar
        viewControllers = [pomodoroNavController, insightsNavController, settingsNavController]
    }
}
