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
    var breathingDuration: Int = 30 // Total time in seconds for the breathing exercise
    var isBreathingPhase: Bool = false // Tracks if currently in the breathing phase
    var wantsBreathing: Bool = true
    private var breathPhase: Int = 0 // Tracks current breath phase (0 for inhale, 1 for exhale)


    private var pendingPhaseSwitch: Bool = false // Track if the phase switch is pending

    func startPomodoro() {
        // Initialize durations and loop counts from user defaults
        self.workDuration = pomoDefaults.workDuration
        self.breakDuration = pomoDefaults.breakDuration
        self.longBreakDuration = pomoDefaults.longBreakDuration
        self.remainingLoops = pomoDefaults.loops
        
        if wantsBreathing {
            // Start in the breathing phase instead of the work phase
            isWorkPhase = false
            isBreathingPhase = true
            remainingTime = breathingDuration  // Set remaining time for breathing exercise
            
            // Notify the presenter to display the breathing exercise UI
            presenter?.displayBreathingExercise("Breathing Exercise")
        } else {
            isWorkPhase = true
            isBreathingPhase = false
            remainingTime = workDuration * 60
            
            presenter?.displayTime(formatTime(remainingTime), isWorkPhase: isWorkPhase, isLongBreak: false)
        }
        
        // Start the breathing timer
        startTimer()
        
        isRunning = true
        isPaused = false
        pendingPhaseSwitch = false  // Ensure no phase switch is pending at start
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
            if isBreathingPhase {
                // Change between breathe in and breathe out
                if breathPhase == 0 {
                    presenter?.displayBreathingExercise("Breathe In...") // Display inhale
                    if remainingTime % 5 == 0 && remainingTime % 10 != 0 {
                        breathPhase = 1 // Switch to exhale
                    }
                } else {
                    presenter?.displayBreathingExercise("Breathe Out...") // Display exhale
                    if remainingTime % 10 == 0 {
                        breathPhase = 0 // Switch to inhale again
                    }
                }
            } else {
                presenter?.displayTime(formatTime(remainingTime), isWorkPhase: isWorkPhase, isLongBreak: false)
            }
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
            scheduleNotification(title: "Ready to Work!", body: "Breathing exercise complete. Press continue to start your work.")
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
                presenter?.displayBreathingExercise("Breathe in...")
                presenter?.displayTime(formatTime(remainingTime), isWorkPhase: false, isLongBreak: true)
                scheduleNotification(title: "Final Long Break", body: "You've completed all work sessions. Enjoy a final long break!")
                pendingPhaseSwitch = true
            } else if remainingLoops % longBreakInterval == 0 && remainingLoops > 0 {
                // Long break every 4 loops
                remainingTime = longBreakDuration * 60
                presenter?.displayBreathingExercise("Breathe in...")
                presenter?.displayTime(formatTime(remainingTime), isWorkPhase: false, isLongBreak: true)
                scheduleNotification(title: "Long Break Time!", body: "You've completed \(longBreakInterval) Pomodoro loops. Time for a long break!")
                pendingPhaseSwitch = true
            } else {
                // Normal break
                remainingTime = breakDuration * 60
                presenter?.displayTime(formatTime(remainingTime), isWorkPhase: false, isLongBreak: false)
                scheduleNotification(title: "Break Time!", body: "Your work session has ended. Time for a break!")
                pendingPhaseSwitch = true
            }
        } else {
            // Break just ended, prepare for breathing exercise before next work
            if remainingLoops > 0 {
                if wantsBreathing {
                    pausePomodoro()
                    isBreathingPhase = true
                    remainingTime = breathingDuration
                    presenter?.displayBreathingExercise("Breathing Exercise")
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
                dataManager.savePomodoro(focusTime: workDuration, breakTime: breakDuration, date: Date(), tag: pomoDefaults.tag?.rawValue ?? "nil")
                stopPomodoro()
                scheduleNotification(title: "Pomodoro Complete!", body: "You've completed all loops and breaks.")
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

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
