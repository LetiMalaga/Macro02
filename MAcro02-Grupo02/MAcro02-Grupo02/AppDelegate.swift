//
//  AppDelegate.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 17/09/24.
//

import UIKit
import BackgroundTasks
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var settingsInteractor: SettingsIteractorProtocol?
    var settingsData: SettingsDataProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Erro ao pedir permissão para notificações: \(error)")
            }
            print("Permissão concedida: \(granted)")
        }
        schedulerTasks()
        if UserDefaults.standard.object(forKey: "sound") == nil {
            self.firstLaunch()
        }
        
//        saveContext()
        return true
        
    }
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ActivitysDataModel") // Substitua "NomeDoSeuModeloDeDados" pelo nome do seu modelo .xcdatamodeld
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("salvo com sucesso")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    private func schedulerTasks() {
        let insightsNotifications = InsightsNotifications()
        insightsNotifications.registerBackgroundTasks()
        insightsNotifications.scheduleDailyBackgroundTask()
        insightsNotifications.scheduleWeeklyBackgroundTask()
    }
    func firstLaunch() {
        if UserDefaults.standard.object(forKey: "sound") == nil {
            UserDefaults.standard.set(true, forKey: "sound")
        }
        if UserDefaults.standard.object(forKey: "vibration") == nil {
            UserDefaults.standard.set(true, forKey: "vibration")
        }
        if UserDefaults.standard.object(forKey: "breathing") == nil {
            UserDefaults.standard.set(true, forKey: "breathing")
        }
        if UserDefaults.standard.object(forKey: "recomendations") == nil {
            UserDefaults.standard.set(true, forKey: "recomendations")
        }
        
        settingsInteractor = SettingsIteractor()
        settingsData = SettingsData()
        settingsData?.parseAndSaveActivities(from: "Atividades_Curtas_Simples")
        settingsData?.parseAndSaveActivities(from: "Atividades_Longas_Simples")
        
    }
}

    



