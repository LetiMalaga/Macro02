//
//  PomodoroInteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import Foundation
import UserNotifications

protocol PomodoroInteractorProtocol {
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

    private var pendingPhaseSwitch: Bool = false // Track if the phase switch is pending

    func startPomodoro() {
        self.workDuration = pomoDefaults.workDuration
        self.breakDuration = pomoDefaults.breakDuration
        self.longBreakDuration = pomoDefaults.longBreakDuration
        self.remainingLoops = pomoDefaults.loops
        isWorkPhase = true
        remainingTime = 5
        isRunning = true
        isPaused = false
        startTimer()
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
        previousPhase = "work"
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
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
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
        if isWorkPhase {
            // Work phase ended, switch to break
            timer?.invalidate()
            isWorkPhase = false
            remainingLoops -= 1  // Decrement after work phase
            remainingTime = 10  // Set remaining time for break
            presenter?.displayTime(formatTime(remainingTime), isWorkPhase: false, isLongBreak: false)
            scheduleNotification(title: "Break Time!", body: "Your work session has ended. Time for a break!")
            pendingPhaseSwitch = true  // Set to true to wait for the "Continuar" button
            if ((remainingLoops+1) % longBreakInterval) == 0 || remainingLoops == 0 {
                // Long break
                timer?.invalidate()
                remainingTime = 20  // Set remaining time for long break
                presenter?.displayTime(formatTime(remainingTime), isWorkPhase: false, isLongBreak: true)
                scheduleNotification(title: "Long Break Time!", body: "You've completed \(longBreakInterval) Pomodoro loops.")
            }
        } else {
            // Break phase ended
             if remainingLoops > 0 {
                // Switch to work phase
                timer?.invalidate()
                isWorkPhase = true
                remainingTime = 5  // Set remaining time for work
                presenter?.displayTime(formatTime(remainingTime), isWorkPhase: true, isLongBreak: false)
                scheduleNotification(title: "Time to Work!", body: "Your break is over. Time to focus!")
            } else {
                // All loops completed, stop Pomodoro
                dataManager.savePomodoro(focusTime: workDuration, breakTime: breakDuration, date: Date(), tag: pomoDefaults.tag?.rawValue ?? "nil")
                stopPomodoro()
                scheduleNotification(title: "Pomodoro Complete!", body: "You've completed all loops.")
            }
            pendingPhaseSwitch = true  // Wait for the user to resume
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

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
