//
//  PomodoroInteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import Foundation
import UserNotifications

protocol PomodoroInteractorProtocol {
    func startPomodoro(workDuration: Int, breakDuration: Int, loopCount: Int)
    func pausePomodoro()
    func resumePomodoro()
    func stopPomodoro()
}

class PomodoroInteractor: PomodoroInteractorProtocol {
    var presenter: PomodoroPresenterProtocol?
    var timer: Timer?
    var remainingTime = 0
    var isRunning = false
    var isPaused = false
    var isWorkPhase = true
    var remainingLoops = 0
    var workDuration = 0   // Store the work duration
    var breakDuration = 0  // Store the break duration

    private var pendingPhaseSwitch: Bool = false // Track if the phase switch is pending

    func startPomodoro(workDuration: Int, breakDuration: Int, loopCount: Int) {
        self.workDuration = workDuration
        self.breakDuration = breakDuration
        remainingLoops = loopCount
        isWorkPhase = true
        remainingTime = workDuration * 60
        isRunning = true
        isPaused = false
        startTimer()
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
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
            startTimer()
        } else {
            startTimer() // Start the timer normally if no phase switch is pending
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
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }

    private func updateTimer() {
        remainingTime -= 1
        if remainingTime <= 0 {
            switchPhase()
        } else {
            presenter?.displayTime(formatTime(remainingTime))
            
        }
        
        presenter?.updateTimer(percentage: percentageTime())
        
        
    }
    
    private func percentageTime() -> Float {
        
        let atual = Float(remainingTime)
        let total = Float((workDuration * 60))
        
        let progress = (1 - atual / total)

        return progress
        
    }

    private func switchPhase() {
        if isWorkPhase {
            // Work phase ended, switch to break
            timer?.invalidate() // Stop the timer
            isWorkPhase = false
            remainingTime = breakDuration * 60 // Set remaining time for break
            presenter?.displayTime(formatTime(remainingTime))
            scheduleNotification(title: "Break Time!", body: "Your work session has ended. Time for a break!") // Notification for break phase
            pendingPhaseSwitch = true // Mark that we need to wait for user to resume
        } else {
            // Break phase ended
            remainingLoops -= 1
            if remainingLoops > 0 {
                // Only switch to work phase if there are remaining loops
                timer?.invalidate() // Stop the timer
                isWorkPhase = true
                remainingTime = workDuration * 60 // Set remaining time for work
                presenter?.displayTime(formatTime(remainingTime))
                scheduleNotification(title: "Time to Work!", body: "Your break is over. Time to focus!") // Notification for work phase
                pendingPhaseSwitch = true // Mark that we need to wait for user to resume
            } else {
                // All loops completed, stop Pomodoro
                stopPomodoro()
                scheduleNotification(title: "Pomodoro Complete!", body: "You've completed all loops. Good job!"); // Notification for completion
            }
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func roundedFloat(_ value: Float, toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return round(value * divisor) / divisor
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
}

