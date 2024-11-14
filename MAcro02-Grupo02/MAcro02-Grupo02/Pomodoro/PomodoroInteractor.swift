//
//  PomodoroInteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import Foundation
import UserNotifications
import SwiftUI
import UIKit
import CloudKit

protocol PomodoroInteractorProtocol {
    var tagTime: String? {get set}
    func startPomodoro()
    func pausePomodoro()
    func resumePomodoro()
    func stopPomodoro()
}

class PomodoroInteractor: PomodoroInteractorProtocol {
    var dataManager: PomodoroData = PomodoroData()
    var presenter: PomodoroPresenterProtocol?
    var pomoDefaults = PomoDefaults()
    var timer: Timer?
    var remainingTime = 0
    var isRunning = false
    var isPaused = false
    var isWorkPhase = true
    var remainingLoops = 0
    var workDuration = 0   // Store the work duration
    var breakDuration = 0  // Store the break duration
    var longBreakDuration = 0 // Store the long break duration
    var longBreakInterval = 4 // Loops until a long break
    var previousPhase = ""
    var breathingDuration: Int = 30 // Total time in seconds for the breathing exercise
    var isBreathingPhase: Bool = false // Tracks if currently in the breathing phase
    @AppStorage("breathing") var wantsBreathing: Bool = true
    private var breathPhase: Int = 0 // Tracks current breath phase (0 for inhale, 1 for exhale)
    private var pendingPhaseSwitch: Bool = false // Track if the phase switch is pending
    private var appDidEnterBackgroundDate: Date?
    var tagTime: String?
    
    var activitySuggestion: ActivitiesModel?
    
    func toggleBreathing() {
        wantsBreathing.toggle()
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func startPomodoro() {
        // Initialize durations and loop counts from user defaults
        self.workDuration = pomoDefaults.workDuration
        self.breakDuration = pomoDefaults.breakDuration
        self.longBreakDuration = pomoDefaults.longBreakDuration
        self.remainingLoops = pomoDefaults.loops
        setupObservers()
        
        
        isWorkPhase = true
        isBreathingPhase = false
        remainingTime = workDuration * 60
        
        presenter?.displayTime(formatTime(remainingTime), isWorkPhase: isWorkPhase, isLongBreak: false)
        
        
        // Start the breathing timer
        startTimer()
        
        appDidEnterBackgroundDate = nil
        isRunning = true
        isPaused = false
        pendingPhaseSwitch = false  // Ensure no phase switch is pending at start
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
    }
    
    @objc func applicationDidEnterBackground(_ notification: Notification) {
        appDidEnterBackgroundDate = Date() // Record the current date when entering background
    }
    
    @objc func applicationWillEnterForeground(_ notification: Notification) {
        guard let previousDate = appDidEnterBackgroundDate else { return }
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.second], from: previousDate, to: Date())
        let seconds = difference.second ?? 0
        
        if !isPaused {
            // Subtract the seconds from remainingTime
            remainingTime -= seconds
        }
        
        // Ensure remainingTime does not go negative
        if remainingTime < 0 {
            remainingTime = 0
        }
        
        // Update the UI accordingly
        presenter?.displayTime(formatTime(remainingTime), isWorkPhase: isWorkPhase, isLongBreak: false)
    }
    
    deinit {
        // Remove observers when the interactor is deallocated
        NotificationCenter.default.removeObserver(self)
    }
    
    func pausePomodoro() {
        isRunning = false
        isPaused = true
        timer?.invalidate()
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // Cancel notifications on pause
    }
    
    func resumePomodoro() {
        isRunning = true
        isPaused = false
        
        // Only start the timer if a phase switch is pending
        if pendingPhaseSwitch {
            pendingPhaseSwitch = false // Reset the pending phase switch
            startTimer()  // Continue to the next phase (work or break)
        } else {
            startTimer()  // If no phase switch is pending, resume normally
        }
        
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
    }
    
    func stopPomodoro() {
        isRunning = false
        isPaused = false
        timer?.invalidate()
        presenter?.resetPomodoro()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // Cancel all pending notifications
    }
    
    private func startTimer() {
        schedulePhaseNotification() // Schedule notification for the current phase duration
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func schedulePhaseNotification() {
        // Calculate the notification trigger time based on remaining time
        let triggerTime = remainingTime
        scheduleNotification(title: phaseEndTitle(), body: phaseEndMessage(), timeInterval: TimeInterval(triggerTime))
    }
    
    private func phaseEndTitle() -> String {
        // Customize title based on the current phase
        if isBreathingPhase { return "Breathing Complete" }
        else if isWorkPhase { return "Work Session Complete" }
        else { return "Break Over" }
    }
    
    private func phaseEndMessage() -> String {
        // Customize message based on the current phase
        if isBreathingPhase { return "Prepare to start your work session." }
        else if isWorkPhase { return "Time for a break!" }
        else { return "Get ready for the next work session." }
    }
    
    private func updateTimer() {
        remainingTime -= 1
        if remainingTime <= 0 {
            switchPhase()
            presenter?.completePomodoro()
        } else {
            
            presenter?.displayTime(formatTime(remainingTime), isWorkPhase: isWorkPhase, isLongBreak: false)
            
        }
        
        presenter?.updateTimer(percentage: percentageTime())
    }
    
    private func percentageTime() -> Float {
        let atual = Float(remainingTime)
        let total = Float((isWorkPhase ? workDuration : breakDuration) * 60)
        return (1 - atual / total)
    }
    
    private func switchPhase() {
        if isBreathingPhase {
            // Breathing phase just ended; set up the next work phase and pause
            pausePomodoro()
            isBreathingPhase = false
            isWorkPhase = true
            remainingTime = workDuration * 60
            presenter?.displayTime(formatTime(remainingTime), isWorkPhase: true, isLongBreak: false)
            
            // Notify the user and pause before the work phase begins
            pendingPhaseSwitch = true
        } else if isWorkPhase {
            // Work phase just ended
            timer?.invalidate()
            isWorkPhase = false
            remainingLoops -= 1
            
            // Check if it's the last loop
            if remainingLoops == 0 {
                // Final long break after last work session, then conclude Pomodoro
                remainingTime = longBreakDuration * 60
                presenter?.displayTime(formatTime(remainingTime), isWorkPhase: false, isLongBreak: true)
                pendingPhaseSwitch = true
            } else if remainingLoops % longBreakInterval == 0 && remainingLoops > 0 {
                // Long break every 4 loops
                remainingTime = longBreakDuration * 60
                presenter?.displayTime(formatTime(remainingTime), isWorkPhase: false, isLongBreak: true)
                pendingPhaseSwitch = true
            } else {
                // All loops completed, stop Pomodoro
                
                
                // Normal break
                remainingTime = breakDuration * 60
                presenter?.displayTime(formatTime(remainingTime), isWorkPhase: false, isLongBreak: false)
                pendingPhaseSwitch = true
            }
        } else {
            // Break just ended, prepare for breathing exercise before next work
            if remainingLoops > 0 {
                if wantsBreathing {
                    pausePomodoro()
                    isBreathingPhase = true
                    pendingPhaseSwitch = true
                } else {
                    pausePomodoro()
                    isBreathingPhase = false
                    isWorkPhase = true
                    remainingTime = 5
                    presenter?.displayTime(formatTime(remainingTime), isWorkPhase: true, isLongBreak: false)
                }
            } else {
                // All loops and final long break completed, end the Pomodoro cycle
                Task {
                    await saveTimeData()
                }
                
                stopPomodoro()
            }
        }
    }
    
    func saveTimeData() async {
        do{
            let data = FocusDataModel(focusTimeInMinutes: workDuration * longBreakInterval, breakTimeinMinutes: breakDuration * longBreakInterval, longBreakTimeInMinutes: longBreakDuration, category: self.tagTime ?? "Sem tag", date: Date())
            
            _ = try await dataManager.savePomodoro(data){ result in
                if case .failure(let error) = result {
                    if let error = error as? CKError{
                        if error.code == . quotaExceeded{
                            self.presenter?.showAlert(with: "Sem espaço para salvar", message: "As informações do seu ciclo de pomodoro não puderam ser salvas devido a falta de espaço em sua conta do iCloud.")
                        }
                    }
                }
            }
        } catch {
            print("Erro ao salvar o registro: \(error)")
        }
    }
    
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func scheduleNotification(title: String, body: String, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    func fetchActivities(_ breakTipe:ActivitiesType,_ tag:String, completion: @escaping (ActivitiesModel) -> Void){
        
        let activity = dataManager.fetchActivities(breakTipe, tag: tag)

        guard let activity else { return }
        completion(ActivitiesModel(id: activity.id,
                                   type: ActivitiesType(rawValue: activity.type) ?? .short,
                                   description: activity.descriptionText,
                                   tag: activity.tag))

    }
}
