//
//  PomodoroPresenterProtocol.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//


import Foundation

protocol PomodoroPresenterProtocol {
    func displayTime(_ time: String)
    func resetPomodoro()
    func updateButton(isRunning: Bool, isPaused: Bool)  // Add this
}

class PomodoroPresenter: PomodoroPresenterProtocol {
    weak var viewController: PomodoroViewController?
    
    func displayTime(_ time: String) {
        viewController?.displayTime(time)
    }
    
    func resetPomodoro() {
        viewController?.displayTime("25:00")
        viewController?.updateButton(isRunning: false, isPaused: false)
    }

    func updateButton(isRunning: Bool, isPaused: Bool) {
        viewController?.updateButton(isRunning: isRunning, isPaused: isPaused)  // Relay button update to view
    }
}