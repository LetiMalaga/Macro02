//
//  Connection.swift
//  Pomdera Watch App
//
//  Created by Luiz Felipe on 21/11/24.
//

import Foundation
import WatchKit
import WatchConnectivity

class WatchConnectivityManager:NSObject, ObservableObject{
    static let shared = WatchConnectivityManager()
    
    var session = WCSession.default
    
    override init (){
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func sendTimerState(_ state: TimerState) {
        guard WCSession.default.isReachable else {
            print("Apple Watch não está conectado.")
            return
        }
        
        do {
            let data = try JSONEncoder().encode(state)
            let message = ["timerState": data]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Erro ao enviar estado do timer: \(error.localizedDescription)")
            })
        } catch {
            print("Erro ao codificar estado do timer: \(error.localizedDescription)")
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print("activationDidCompleteWith")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let data = message["timerState"] as? Data {
            do {
                let state = try JSONDecoder().decode(TimerState.self, from: data)
                // Atualize o timer localmente com o estado recebido
                TimerConnectionManager.shared.updateTimer(with: state)
            } catch {
                print("Erro ao decodificar estado do timer: \(error.localizedDescription)")
            }
        }
    }
}
