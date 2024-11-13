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
//    func displayBreathingExercise(_ time: String) // New method to show breathing start
//    func displayBreathingExerciseTime(_ time: String) // Show countdown for breathing
    func resetPomodoro()
    func updateButton(isRunning: Bool, isPaused: Bool)
    func updateTimer(percentage: Float)
    func completePomodoro()
    func presentActivity(_ activity: ActivitiesModel)
}

class PomodoroPresenter: PomodoroPresenterProtocol {
    weak var viewController: PomodoroViewController?
    let pomoDefaults = PomoDefaults()

    func presentActivity(_ activity: ActivitiesModel) {
            let description = activity.description // Extract description text
            viewController?.displayActivity(description) // Send it to the view controller
        
        print("the activity is: \(description)")
        }
    
    func displayTime(_ time: String, isWorkPhase: Bool, isLongBreak: Bool = false) {
            viewController?.displayTime(time, isWorkPhase: isWorkPhase, isLongBreak: isLongBreak)
        }

    func resetPomodoro() {
        let initialTime = String(format: "%02d:00", pomoDefaults.workDuration)
        viewController?.displayTime(initialTime, isWorkPhase: true, isLongBreak: false)
    }
    
//    func displayBreathingExercise(_ time: String) {
//            viewController?.showBreathingExercise(time) // New method in view controller
//        }
//    
//    func displayBreathingExerciseTime(_ time: String) {
//            viewController?.displayBreathingTime(time) // Show breathing countdown
//        }


    func updateButton(isRunning: Bool, isPaused: Bool) {
    }
    
    func updateTimer(percentage: Float) {
        viewController?.updateCircle(percentage: percentage)
    }
    
    func completePomodoro() {
        viewController?.complete()
    }
}



