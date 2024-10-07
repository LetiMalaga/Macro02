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
    private let counterKey = "PomodoroCount"
    var counter: Int {
        get {
            // Recupera o valor do contador salvo no UserDefaults, caso não exista, retorna 0
            return UserDefaults.standard.integer(forKey: counterKey)
        }
        set {
            // Atualiza o valor do contador no UserDefaults
            UserDefaults.standard.set(newValue, forKey: counterKey)
        }
    }
    var presenter: PomodoroPresenterProtocol?
    var timer: Timer?
    var remainingTime = 0
    var isRunning = false
    var isPaused = false
    var isWorkPhase = true
    var remainingLoops = 0
    var workDuration = 0   // Store the work duration
    var breakDuration = 0  // Store the break duration
    
    func startPomodoro(workDuration: Int, breakDuration: Int, loopCount: Int) {
        self.workDuration = workDuration  // Store the work duration
        self.breakDuration = breakDuration  // Store the break duration
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
    }
    
    func resumePomodoro() {
        isRunning = true
        isPaused = false
        startTimer()
        presenter?.updateButton(isRunning: isRunning, isPaused: isPaused)
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
            switchPhase()
        } else {
            presenter?.displayTime(formatTime(remainingTime))
        }
    }
    
    private func switchPhase() {
        if isWorkPhase {
            // Work phase ended, switch to break
            isWorkPhase = false
            remainingTime = breakDuration * 60
            presenter?.displayTime(formatTime(remainingTime))
            presenter?.updateStateLabel("Break Time!")
        } else {
            // Break phase ended
            remainingLoops -= 1
            if remainingLoops > 0 {
                // Switch back to work
                isWorkPhase = true
                remainingTime = workDuration * 60
                presenter?.displayTime(formatTime(remainingTime))
                presenter?.updateStateLabel("Time to Work!")
            } else {
                // All loops completed, stop Pomodoro
                stopPomodoro()
                
                //adicionar icloud
                counter += 1
                
            }
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
