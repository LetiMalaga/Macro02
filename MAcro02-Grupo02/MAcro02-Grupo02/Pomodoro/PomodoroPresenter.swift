//
//  PomodoroPresenterProtocol.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import Foundation
import SwiftUI

protocol PomodoroPresenterProtocol {
    func displayTime(_ time: String, isWorkPhase: Bool, isLongBreak: Bool)
    func resetPomodoro()
    func updateButton(isRunning: Bool, isPaused: Bool)
    func updateTimer(percentage: Float)
    func completePomodoro()
}

class PomodoroPresenter: PomodoroPresenterProtocol {
    weak var viewController: PomodoroViewController?
    let pomoDefaults = PomoDefaults()

    func displayTime(_ time: String, isWorkPhase: Bool, isLongBreak: Bool = false) {
            viewController?.displayTime(time, isWorkPhase: isWorkPhase, isLongBreak: isLongBreak)
        }

    func resetPomodoro() {
        let initialTime = String(format: "%02d:00", pomoDefaults.workDuration)
        viewController?.displayTime(initialTime, isWorkPhase: true, isLongBreak: false)
    }

    func updateButton(isRunning: Bool, isPaused: Bool) {
    }
    
    func updateTimer(percentage: Float) {
        viewController?.updateCircle(percentage: percentage)
    }
    
    func completePomodoro() {
        viewController?.complete()
    }
}

#Preview {
    
}

