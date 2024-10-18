//
//  AppDelegate.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 17/09/24.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let insightsNotifications = InsightsNotifications()
        insightsNotifications.registerBackgroundTasks()
        insightsNotifications.scheduleDailyBackgroundTask()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Erro ao pedir permissão para notificações: \(error)")
            }
            print("Permissão concedida: \(granted)")
        }
        return true
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        let insightsNotifications = InsightsNotifications()
        insightsNotifications.registerBackgroundTasks()
        insightsNotifications.scheduleDailyBackgroundTask()
    }
}

    



