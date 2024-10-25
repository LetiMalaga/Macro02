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
    func updateTimer(percentage:Float)
    func completePomodoro()
}

class PomodoroPresenter: PomodoroPresenterProtocol {
    weak var viewController: PomodoroViewController?
    let pomoDefaults = PomoDefaults()

    func displayTime(_ time: String) {
        viewController?.displayTime(time)
    }

    func resetPomodoro() {
        viewController?.displayTime(String(format: "%02d:00", pomoDefaults.workDuration))
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

