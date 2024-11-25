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

        let tabBar =  TesteDeConexao()

        let navControler = UINavigationController(rootViewController: tabBar )
        window.rootViewController = navControler


        window.makeKeyAndVisible()


        self.window = window
    }
}
