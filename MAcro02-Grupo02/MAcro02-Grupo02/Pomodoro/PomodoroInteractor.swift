//
//  PomodoroInteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import Foundation

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

    func startPomodoro(workDuration: Int, breakDuration: Int, loopCount: Int) {
        remainingTime = workDuration * 60
        isRunning = true
        isPaused = false
        startTimer()
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused) // Notify presenter to update button
    }

    func pausePomodoro() {
        isRunning = false
        isPaused = true
        timer?.invalidate()
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused) // Notify presenter to update button
    }

    func resumePomodoro() {
        isRunning = true
        isPaused = false
        startTimer()
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused) // Notify presenter to update button
    }

    func stopPomodoro() {
        isRunning = false
        isPaused = false
        timer?.invalidate()
        presenter?.resetPomodoro()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }

    private func updateTimer() {
        remainingTime -= 1
        if remainingTime <= 0 {
            stopPomodoro()
        } else {
            presenter?.displayTime(formatTime(remainingTime))
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
