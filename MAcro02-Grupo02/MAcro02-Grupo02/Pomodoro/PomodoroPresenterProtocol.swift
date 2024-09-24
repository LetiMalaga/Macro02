//
//  PomodoroPresenterProtocol.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//


import Foundation

protocol PomodoroPresenterProtocol {
    func presentTime(minutes: Int, seconds: Int)
    func updateButton(isRunning: Bool)
}

class PomodoroPresenter: PomodoroPresenterProtocol {
    weak var viewController: PomodoroViewController?

    func presentTime(minutes: Int, seconds: Int) {
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        viewController?.displayTime(timeString)
    }
    
    func updateButton(isRunning: Bool) {
        viewController?.updateButton(isRunning: isRunning)
    }
}
