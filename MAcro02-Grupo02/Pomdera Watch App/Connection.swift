//
//  Connection.swift
//  Pomdera Watch App
//
//  Created by Luiz Felipe on 21/11/24.
//

import Foundation
import WatchKit
import WatchConnectivity


class Connection:NSObject, ObservableObject{
    var message:String = ""
    
    var session = WCSession.default
    
    override init (){
        super.init()
        session.delegate = self
        session.activate()
    }
    func sendMessage(){
        let data:[String:Any] = ["watch": "teste de mensagem" as Any]
        
        session.sendMessage(data, replyHandler: nil) { error in
                print("erro no envio do watch -> \(error.localizedDescription)")
            
        }
    }
    
}
extension Connection: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print("activationDidCompleteWith")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
        if let message = message["iPhone"] as? String{
            DispatchQueue.main.async {
                self.message = message
            }
        }
    }
    
    
    
}
