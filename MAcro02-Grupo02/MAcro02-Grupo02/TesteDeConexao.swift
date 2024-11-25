//
//  TesteDeConexao.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 21/11/24.
//

import Foundation
import UIKit
import WatchConnectivity

class TesteDeConexao: UIViewController{
    
    var session: WCSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuraConexao()
        setupUI()
    }
    
    
    lazy var labelTeste:UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        return label
    }()
    
    lazy var buttonTeste:UIButton = {
        let button = UIButton()
        button.setTitle("Send Message", for: .normal)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    func setupUI(){
        view.addSubview(labelTeste)
        view.addSubview(buttonTeste)
        
        labelTeste.translatesAutoresizingMaskIntoConstraints = false
        buttonTeste.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelTeste.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelTeste.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            buttonTeste.topAnchor.constraint(equalTo: labelTeste.bottomAnchor, constant: 20),
            buttonTeste.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ])
        
        
    }
        
    
    
    func configuraConexao(){
        if WCSession.isSupported(){
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    @objc func sendMessage(_ sender: UIButton){
        if let validSession = self.session, validSession.isReachable{
            let data:[String: Any] = ["iPhone": "message from iPhone" as Any]
            validSession.sendMessage(data, replyHandler: nil)
        }
    }
}
extension TesteDeConexao: WCSessionDelegate{
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
        print("Received message: \(message)")
        DispatchQueue.main.async {
            if let value = message["watch"] as? String{
                DispatchQueue.main.async {
                    self.labelTeste.text = value
                }
            }
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print(session.isReachable)
        var isReachable: Bool = false
        if WCSession.default.activationState == .activated{
            isReachable = WCSession.default.isReachable
        }
        DispatchQueue.main.async {
            self.labelTeste.textColor = isReachable ? .green : .red
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCConnection is inactive")
    }
    
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCConnection is deactivated")
    }
}
