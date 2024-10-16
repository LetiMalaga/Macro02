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
<<<<<<< HEAD
        let pomodoroVC = PomodoroModuleBuilder().build()
        let insightVC = InsightsViewController()
        window.rootViewController = insightVC
=======
          let pomodoroVC = PomodoroModuleBuilder().build()
        
          let navControler = UINavigationController(rootViewController: pomodoroVC)
          
        window.rootViewController = navControler
>>>>>>> 803b3df36ed59b6a8db2a95d5b3f0c4405b60edb
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

