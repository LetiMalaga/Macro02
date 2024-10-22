//
//  SceneDelegate.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 17/09/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
    
// POMODORO

          let window = UIWindow(windowScene: windowScene)
        let pomodoroVC = PomodoroModuleBuilder().build()
        let insightVC = InsightsFactory.makeInsights()
        window.rootViewController = insightVC
        
        let navControler = UINavigationController(rootViewController: insightVC)
          
          window.makeKeyAndVisible()

//        let window = UIWindow(windowScene: windowScene)
//        
//        let vc = ActivitiesViewController()
//        
//        window.rootViewController = vc
//        window.makeKeyAndVisible()
        
        self.window = window
    }
}

