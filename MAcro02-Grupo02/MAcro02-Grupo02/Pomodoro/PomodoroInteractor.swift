//
//  PomodoroInteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import UIKit
import UserNotifications

protocol PomodoroInteractorProtocol {
    func startPomodoro(workDuration: Int, breakDuration: Int, loopCount: Int, longRestDuration: Int, wantsBreathing: Bool)
    func pausePomodoro()
    func resumePomodoro()
    func stopPomodoro()
    func updateTimer()
}

class PomodoroInteractor: PomodoroInteractorProtocol {
    
    var presenter: PomodoroPresenterProtocol?
    var timer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var remainingTime = 0
    var isRunning = false
    var isPaused = false
    var isWorkPhase = true
    var wantsBreathing: Bool = false
    var remainingLoops = 0
    var workDuration = 0
    var breakDuration = 0
    var longRestDuration = 0
    private var pendingPhaseSwitch: Bool = false
    private var breathingTime = 30
    private var breathingTimer: Timer?
    private var isBreakCompleted = false // Flag to track if break is completed
    
    func startPomodoro(workDuration: Int, breakDuration: Int, loopCount: Int, longRestDuration: Int, wantsBreathing: Bool) {
        self.workDuration = workDuration
        self.breakDuration = breakDuration
        self.longRestDuration = longRestDuration
        self.wantsBreathing = wantsBreathing
        remainingLoops = loopCount
        isWorkPhase = true
        remainingTime = workDuration * 60
        isRunning = true
        isPaused = false
        if wantsBreathing {
            startBreathingExercise() // Start breathing before work session
            presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
            presenter?.updateStateLabel("Time to Breathe!")
        } else {
            startTimer()
            presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
            presenter?.updateStateLabel("Time to Work!")
        }
        registerForAppStateNotifications()
    }
    
    func pausePomodoro() {
        isRunning = false
        isPaused = true
        timer?.invalidate()
        breathingTimer?.invalidate() // Stop the breathing timer if it’s running
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        endBackgroundTask()
    }
    
    func resumePomodoro() {
        isRunning = true
        isPaused = false
        
        if pendingPhaseSwitch && isBreakCompleted {
            // Start breathing if resuming after a break
            if wantsBreathing {
                startBreathingExercise()
            } else {
                startTimer()
            }
        } else {
            startTimer() // Just resume the timer if resuming from a pause
        }
        
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
        isBreakCompleted = false // Reset after resuming
        startBackgroundTask()
    }
    
    func stopPomodoro() {
        isRunning = false
        isPaused = false
        timer?.invalidate()
        breathingTimer?.invalidate()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        endBackgroundTask()
    }
    
    private func startBreathingExercise() {
        var breatheIn = true
        breathingTime = 30
        breathingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.breathingTime <= 0 {
                self.breathingTimer?.invalidate()
                self.startTimer()
                self.presenter?.updateStateLabel("Time to Work!")
                return
            }
            
            if breatheIn {
                self.presenter?.updateStateLabel("Breathe In...")
            } else {
                self.presenter?.updateStateLabel("Breathe Out...")
            }
            
            breatheIn.toggle()
            self.breathingTime -= 5
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
        startBackgroundTask() // Start background task when the timer starts
    }
    
    internal func updateTimer() {
        remainingTime -= 1
        if remainingTime <= 0 {
            switchPhase()
        } else {
            presenter?.displayTime(formatTime(remainingTime))
        }
    }
    
    private func switchPhase() {
        if isWorkPhase {
            timer?.invalidate()
            
            if remainingLoops > 1 {
                remainingLoops -= 1
                // Normal work-to-break transition
                isWorkPhase = false
                remainingTime = breakDuration * 60
                presenter?.displayTime(formatTime(remainingTime))
                presenter?.updateStateLabel("Break Time!")
                scheduleNotification(title: "Break Time!", body: "Your work session has ended. Time for a break!")
            } else {
                // Last work session completed, go directly to long rest
                remainingLoops -= 1
                isWorkPhase = false
                remainingTime = longRestDuration * 60
                presenter?.displayTime(formatTime(remainingTime))
                presenter?.updateStateLabel("Long Rest Time!")
                scheduleNotification(title: "Long Rest Time!", body: "All work loops completed. Enjoy your long rest!")
            }
            
            // Prepare for break or long rest
            pendingPhaseSwitch = true
            isRunning = false
            isPaused = true
            presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
        } else {
            // Break or long rest phase completed
            if remainingLoops > 0 {
                // Break completed, move back to work session
                timer?.invalidate()
                print(remainingLoops)
                isWorkPhase = true
                remainingTime = workDuration * 60
                presenter?.displayTime(formatTime(remainingTime))
                presenter?.updateStateLabel("Time to Work!")
                scheduleNotification(title: "Time to Work!", body: "Your break is over. Time to focus!")
                pendingPhaseSwitch = true
                isBreakCompleted = true // Mark that we need to start breathing when resuming
                isRunning = false
                isPaused = true
                presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
            } else {
                // Long rest phase completed, conclude the Pomodoro
                timer?.invalidate()
                isRunning = false
                isPaused = false
                presenter?.updateStateLabel("Pomodoro Complete!")
                presenter?.displayTime(formatTime(0)) // Display 00:00 to indicate the end
                scheduleNotification(title: "Pomodoro Complete!", body: "You've completed the Pomodoro session!")
                presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
                stopPomodoro() // Conclude the Pomodoro session
            }
        }
    }

    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func scheduleNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // Create the trigger for an immediate notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    // MARK: - Background Task Management
    
    private func registerForAppStateNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func appMovedToBackground() {
        startBackgroundTask()
    }
    
    @objc private func appMovedToForeground() {
        endBackgroundTask()
    }
    
    private func startBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            // End the task if time expires
            self.endBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
}
