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
    func updateProgress(percentage: Float)  // New function for updating the progress circle
}

class PomodoroPresenter: PomodoroPresenterProtocol {
    weak var viewController: PomodoroViewController?

    // Display the current time on the timer label
    func displayTime(_ time: String) {
        viewController?.displayTime(time)
    }

    // Reset the Pomodoro session and update the UI accordingly
    func resetPomodoro() {
        viewController?.displayTime("25:00")
        viewController?.updateButton(isRunning: false, isPaused: false)
        viewController?.updateStateLabel("Time to Work!")
        viewController?.updateCircle(percentage: 0)  // Reset the progress circle
    }

    // Update the UI button state based on whether the session is running or paused
    func updateButton(isRunning: Bool, isPaused: Bool) {
        viewController?.updateButton(isRunning: isRunning, isPaused: isPaused)
    }

    // Update the label for the current state (e.g., "Time to Work", "Break Time", "Breathe In")
    func updateStateLabel(_ text: String) {
        viewController?.updateStateLabel(text)
    }

    // New method to update the progress circle with the percentage passed from the interactor
    func updateProgress(percentage: Float) {
        viewController?.updateCircle(percentage: percentage)
    }
}

#Preview {
    // No preview logic needed here
}
