//
//  TesteDeConexao.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 21/11/24.
//

import Foundation
import UIKit
import WatchConnectivity

class PhoneConnectivityManager: NSObject{
    static let shared = PhoneConnectivityManager()
    
    var session: WCSession?
    
    private override init() {
        super.init()
        configuraConexao()
    }
    
    func configuraConexao(){
        if WCSession.isSupported(){
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
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

extension PhoneConnectivityManager: WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error{
            print("WCConnection fail with \(error.localizedDescription)")
            return
        }
        if WCSession.default.isReachable{
            print("WCConnection is reachable")
        }else{
            print("WCConnection is not reachable")
        }
    }
    
    func sessionDidReceiveMessage(_ session: WCSession, didReceiveMessage message: [String : Any]) {
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
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print(session.isReachable)
        var isReachable: Bool = false
        if WCSession.default.activationState == .activated{
            isReachable = WCSession.default.isReachable
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCConnection is inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCConnection is deactivated")
    }
}
