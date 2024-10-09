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
    var workDuration = 0
    var breakDuration = 0
    private var pendingPhaseSwitch: Bool = false
    private var breathingTime = 30
    private var breathingTimer: Timer?
    private var isBreakCompleted = false // Flag to track if break is completed

    func startPomodoro(workDuration: Int, breakDuration: Int, loopCount: Int) {
        self.workDuration = workDuration
        self.breakDuration = breakDuration
        remainingLoops = loopCount
        isWorkPhase = true
        remainingTime = workDuration * 60
        isRunning = true
        isPaused = false
        startBreathingExercise() // Start breathing before work session
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
        presenter?.updateStateLabel("Time to Breathe!")
    }

    func pausePomodoro() {
        isRunning = false
        isPaused = true
        timer?.invalidate()
        breathingTimer?.invalidate() // Stop the breathing timer if it’s running
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func resumePomodoro() {
        isRunning = true
        isPaused = false

        if pendingPhaseSwitch && isBreakCompleted {
            // Start breathing if resuming after a break
            startBreathingExercise()
        } else {
            startTimer() // Just resume the timer if resuming from a pause
        }

        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
        isBreakCompleted = false // Reset after resuming
    }

    func stopPomodoro() {
        isRunning = false
        isPaused = false
        timer?.invalidate()
        breathingTimer?.invalidate()
        presenter?.resetPomodoro()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
    }

    private func updateTimer() {
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
            isWorkPhase = false
            remainingTime = breakDuration * 60
            presenter?.displayTime(formatTime(remainingTime))
            presenter?.updateStateLabel("Break Time!")
            scheduleNotification(title: "Break Time!", body: "Your work session has ended. Time for a break!")
            pendingPhaseSwitch = true
            isRunning = false
            isPaused = true
            presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
        } else {
            remainingLoops -= 1
            if remainingLoops > 0 {
                timer?.invalidate()
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
                stopPomodoro()
                presenter?.updateStateLabel("Pomodoro Complete!")
                scheduleNotification(title: "Pomodoro Complete!", body: "You've completed all loops. Good job!")
            }
        }
    }


    private func formatTime(_ seconds: Int) -> String {
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
}

