//
//  PomodoroPresenterProtocol.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import Foundation
import SwiftUI

protocol PomodoroPresenterProtocol {
    func displayTime(_ time: String)
    func resetPomodoro()
    func updateButton(isRunning: Bool, isPaused: Bool)
    func updateStateLabel(_ text: String)
}

class PomodoroPresenter: PomodoroPresenterProtocol {
    weak var viewController: PomodoroViewController?

    func displayTime(_ time: String) {
        viewController?.displayTime(time)
    }

    func resetPomodoro() {
        viewController?.displayTime("25:00")
        viewController?.updateButton(isRunning: false, isPaused: false)
        viewController?.updateStateLabel("Time to Work!")
    }

    func updateTimerDisplay(time: String, progress: Float) {
        viewController?.displayTime(time)
        viewController?.updateTimerCircleProgress(progress)
    }
    
    func updateButton(isRunning: Bool, isPaused: Bool) {
        viewController?.updateButton(isRunning: isRunning, isPaused: isPaused)
    }

    func updateStateLabel(_ text: String) {
        viewController?.updateStateLabel(text)
    }
}

#Preview {
    
}

