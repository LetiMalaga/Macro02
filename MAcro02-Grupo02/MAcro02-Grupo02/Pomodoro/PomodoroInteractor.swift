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
    var remainingLoops = 0
    var workDuration = 0
    var breakDuration = 0

    private var pendingPhaseSwitch: Bool = false
    private var breathingTime = 30
    private var breathingTimer: Timer?
    private var isBreakCompleted = false

    // Define the phases of the Pomodoro
    enum PomodoroPhase {
        case work
        case rest
        case breathing
        case complete
    }

    var currentPhase: PomodoroPhase = .work // Track the current phase

    func startPomodoro(workDuration: Int, breakDuration: Int, loopCount: Int) {
        self.workDuration = workDuration
        self.breakDuration = breakDuration
        remainingLoops = loopCount
        isRunning = true
        isPaused = false
        currentPhase = .breathing // Start with the breathing phase before work
        startBreathingExercise()
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
        presenter?.updateStateLabel("Time to Breathe!")
    }

    func pausePomodoro() {
        isRunning = false
        isPaused = true
        timer?.invalidate()
        breathingTimer?.invalidate()
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func resumePomodoro() {
        isRunning = true
        isPaused = false

        if pendingPhaseSwitch && isBreakCompleted {
            currentPhase = .breathing
            startBreathingExercise()
        } else {
            startTimer()
        }

        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
        isBreakCompleted = false
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
        currentPhase = .breathing
        var breatheIn = true
        breathingTime = 30
        breathingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.breathingTime <= 0 {
                self.breathingTimer?.invalidate()
                self.switchPhase()
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
        currentPhase = .work
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
        switch currentPhase {
        case .work:
            handleWorkPhaseEnd()

        case .rest:
            handleBreakPhaseEnd()

        case .breathing:
            handleBreathingPhaseEnd()

        case .complete:
            stopPomodoro()
            presenter?.updateStateLabel("Pomodoro Complete!")
            scheduleNotification(title: "Pomodoro Complete!", body: "You've completed all loops. Good job!")
        }
    }

    private func handleWorkPhaseEnd() {
        timer?.invalidate()
        currentPhase = .rest
        remainingTime = breakDuration * 60
        presenter?.displayTime(formatTime(remainingTime))
        presenter?.updateStateLabel("Break Time!")
        scheduleNotification(title: "Break Time!", body: "Your work session has ended. Time for a break!")
        pendingPhaseSwitch = true
        isRunning = false
        isPaused = true
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
    }

    private func handleBreakPhaseEnd() {
        timer?.invalidate()
        remainingLoops -= 1
        if remainingLoops > 0 {
            currentPhase = .breathing
            startBreathingExercise()
            isBreakCompleted = true
        } else {
            currentPhase = .complete
            switchPhase()
        }
    }

    private func handleBreathingPhaseEnd() {
        currentPhase = .work
        remainingTime = workDuration * 60
        presenter?.displayTime(formatTime(remainingTime))
        presenter?.updateStateLabel("Time to Work!")
        startTimer()
        pendingPhaseSwitch = true
        isRunning = false
        isPaused = true
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
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

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}

