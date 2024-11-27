//
//  TimerConnectionManager.swift
//  Pomdera Watch App
//
//  Created by Luiz Felipe on 27/11/24.
//

import Foundation

class TimerConnectionManager {
    static let shared = TimerConnectionManager()
    private var timer: Timer?
    private(set) var state: TimerState = TimerState(activity: nil, isRunning: false, startTime: nil, remainingTime: 0)
    
    private init() {}
    
    func startTimer(duration: TimeInterval) {
        state = TimerState(activity: nil, isRunning: true, startTime: Date(), remainingTime: duration)
        syncTimerState()
        scheduleTimer()
    }
    
    func pauseTimer() {
        timer?.invalidate()
        state = TimerState(activity: nil, isRunning: false, startTime: nil, remainingTime: state.remainingTime - Date().timeIntervalSince(state.startTime ?? Date()))
        syncTimerState()
    }
    
    func updateTimer(with newState: TimerState) {
        timer?.invalidate()
        state = newState
        if state.isRunning {
            scheduleTimer()
        }
    }
    
    private func scheduleTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: state.remainingTime, repeats: false) { [weak self] _ in
            self?.state = TimerState(activity: nil, isRunning: false, startTime: nil, remainingTime: 0)
            self?.syncTimerState()
        }
    }
    
    private func syncTimerState() {
#if os(iOS)
        PhoneConnectivityManager.shared.sendTimerState(state)
#elseif os(watchOS)
        WatchConnectivityManager.shared.sendTimerState(state)
#endif
    }
}
struct TimerState: Codable {
    let activity:String?
    let isRunning: Bool
    let startTime: Date?  // Hora de início, se aplicável
    let remainingTime: TimeInterval // Tempo restante em segundos
}
