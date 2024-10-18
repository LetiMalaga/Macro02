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
//        if let savedData = UserDefaults.standard.data(forKey: "Insights"),
//           let decodedInsights = try? JSONDecoder().decode(InsightsDataModel.self, from: savedData) {
//            content.body = "Você focou por \(decodedInsights.timeFocusedInMinutes[.focus] ?? 0) minutos hoje. Continue assim!"
//        } else {
//            print("No data found")
//        }
        print("Found data")

        content.body = "Você focou por \(250) minutos hoje. Continue assim!"
        content.sound = .default
        
        // Configurar para notificar ao final do dia (23:59)
        var dateComponents = DateComponents()
        dateComponents.hour = 17
        dateComponents.minute = 53
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        print("Notificação diária agendada para: \(trigger.nextTriggerDate()!)")
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleEndOfWeekNotification(insights: InsightsDataModel) {
        let content = UNMutableNotificationContent()
        content.title = "Resumo da sua semana"
        if let savedData = UserDefaults.standard.data(forKey: "Insights"),
           let decodedInsights = try? JSONDecoder().decode(InsightsDataModel.self, from: savedData) {
            content.body = "Você focou por \(decodedInsights.timeFocusedInMinutes.values.max() ?? 0) minutos nesta semana. Continue melhorando!"
            print("Found data")
        } else {
            print("No data found")
        }
        content.sound = .default
        
        // Configura para o último dia da semana (Domingo às 23:59)
        var dateComponents = DateComponents()
        dateComponents.weekday = 1  // Domingo
        dateComponents.hour = 23
        dateComponents.minute = 59
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        print("Notificação semanal agendada para: \(trigger.nextTriggerDate()!)")
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func registerBackgroundTasks() {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: "DayNotification", using: nil) { task in
                self.handleDailyTask(task: task as! BGAppRefreshTask)
            }
            BGTaskScheduler.shared.register(forTaskWithIdentifier: "WeekNotification", using: nil) { task in
                self.handleWeeklyTask(task: task as! BGAppRefreshTask)
            }
        }
    func scheduleDailyBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "DayNotification")
        
        // Definir a hora mais cedo para começar (por exemplo, ao final do dia)
        request.earliestBeginDate = Calendar.current.date(bySettingHour: 17, minute: 53, second: 0, of: Date())
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Daily task scheduled")
        } catch {
            print("Failed to schedule daily task: \(error)")
        }
    }

    func scheduleWeeklyBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "WeekNotification")
        
        // Definir a hora para o final da semana (por exemplo, domingo às 23h59)
        if let nextSunday = getNextSunday() {
            request.earliestBeginDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: nextSunday)
            
            do {
                try BGTaskScheduler.shared.submit(request)
                print("Weekly task scheduled")
            } catch {
                print("Failed to schedule weekly task: \(error)")
            }
        }
    }
    
    func handleDailyTask(task: BGAppRefreshTask) {
        // Agendar a próxima execução
        scheduleDailyBackgroundTask()
        
        // Buscar dados da nuvem e calcular os insights
        if let savedData = UserDefaults.standard.data(forKey: "Insights"),
           let decodedInsights = try? JSONDecoder().decode(InsightsDataModel.self, from: savedData) {
            scheduleEndOfDayNotification(insights: decodedInsights)
        } else {
            print("No data found")
        }
            // Finalizar a tarefa
            task.setTaskCompleted(success: true)
        
    }

    func handleWeeklyTask(task: BGAppRefreshTask) {
        // Agendar a próxima execução
        scheduleWeeklyBackgroundTask()
        
        // Buscar dados da nuvem e calcular os insights
        if let savedData = UserDefaults.standard.data(forKey: "Insights"),
           let decodedInsights = try? JSONDecoder().decode(InsightsDataModel.self, from: savedData) {
            scheduleEndOfWeekNotification(insights: decodedInsights)
        } else {
            print("No data found")
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
