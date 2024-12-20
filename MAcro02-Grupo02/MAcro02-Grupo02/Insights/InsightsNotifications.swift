//
//  InsightsNotifications.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 11/10/24.
//

import Foundation
import UserNotifications
import BackgroundTasks

class InsightsNotifications {
    
    func scheduleEndOfDayNotification(insights: InsightsDataModel){
        let content = UNMutableNotificationContent()
        content.title = "Resumo do seu dia"
        if insights.timeFocusedInMinutes.values.reduce(0, +) > 0 {
            content.body = "Você focou por \(insights.timeFocusedInMinutes.values.reduce(0, +)) minutos hoje. Continue assim!"
        }else {
            content.body = "Venha conferir seus insights!"
        }
        
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            print("Error: \(error?.localizedDescription ?? "No error")")
        }
    }
    
    func scheduleEndOfWeekNotification(insights: InsightsDataModel) {
        let content = UNMutableNotificationContent()
        content.title = "Resumo da sua semana"
        if insights.timeFocusedInMinutes.values.reduce(0, +) > 0 {
            content.body = "Você focou por \(insights.timeFocusedInMinutes.values.max() ?? 0) minutos nesta semana. Continue melhorando!"
        } else {
            content.body = "Venha conferir seus insights!"
        }
        content.sound = .default
        var dateComponents = DateComponents()
        dateComponents.weekday = 1
        dateComponents.hour = 20
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            print("Error: \(error?.localizedDescription ?? "No error")")
        }
    }
    
    func registerBackgroundTasks() {
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "DayNotification.PomoBreak.Notification", using: nil) { [weak self] task in
            guard let task = task as? BGProcessingTask else { return }
            self?.handleDailyTask(task: task)
        }
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "WeekNotification.PomoBreak.Notification", using: nil) {[weak self] task in
            guard let task = task as? BGProcessingTask else { return }
            self?.handleWeeklyTask(task: task)
        }
    }
    func scheduleDailyBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: "DayNotification.PomoBreak.Notification")
        
        request.earliestBeginDate = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date())
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Failed to schedule daily task: \(error)")
        }
    }
    
    func scheduleWeeklyBackgroundTask() {
        let insightsInteractor: InsightsInteractorProtocol = InsightsInteractor()

        let request = BGProcessingTaskRequest(identifier: "WeekNotification.PomoBreak.Notification")
        
        insightsInteractor.insightsPerWeek()
        if let nextSunday = getNextSunday() {
            request.earliestBeginDate = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: nextSunday)
            request.requiresNetworkConnectivity = true
            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("Failed to schedule weekly task: \(error)")
            }
        }
    }
    
    func handleDailyTask(task: BGProcessingTask) {
        let insightsInteractor: InsightsInteractorProtocol = InsightsInteractor()

        scheduleDailyBackgroundTask()
        
        insightsInteractor.insightsPerDay()
        if let savedData = UserDefaults.standard.data(forKey: "InsightsDay"),
           let decodedInsights = try? JSONDecoder().decode(InsightsDataModel.self, from: savedData) {
            scheduleEndOfDayNotification(insights: decodedInsights)
        }
        task.setTaskCompleted(success: true)
        
    }
    
    func handleWeeklyTask(task: BGProcessingTask) {
        scheduleWeeklyBackgroundTask()
        
        if let savedData = UserDefaults.standard.data(forKey: "InsightsWeek"),
           let decodedInsights = try? JSONDecoder().decode(InsightsDataModel.self, from: savedData) {
            scheduleEndOfWeekNotification(insights: decodedInsights)
        } else {
            scheduleEndOfDayNotification(insights: InsightsDataModel(timeFocusedInMinutes: [:], timeTotalInMinutes: 0, timeBreakInMinutes: 0))
        }
        task.setTaskCompleted(success: true)
        
    }
    func getNextSunday() -> Date? {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysUntilSunday = (8 - weekday) % 7
        return calendar.date(byAdding: .day, value: daysUntilSunday, to: today)
    }
}
