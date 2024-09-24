//
//  PomodoroInteractor.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import Foundation

protocol PomodoroInteractorProtocol {
    func startStopPomodoro()
}

class PomodoroInteractor: PomodoroInteractorProtocol {
    var presenter: PomodoroPresenterProtocol?
    var timer: Timer?
    var isRunning = false
    var remainingTime = 25 * 60  // 25 minutos em segundos
    
    func startStopPomodoro() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        isRunning = true
        presenter?.updateButton(isRunning: true)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        isRunning = false
        presenter?.updateButton(isRunning: false)
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateTimer() {
        remainingTime -= 1
        if remainingTime <= 0 {
            stopTimer()
            remainingTime = 25 * 60  // Reinicia o ciclo
        }
        
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        presenter?.presentTime(minutes: minutes, seconds: seconds)
    }
}
