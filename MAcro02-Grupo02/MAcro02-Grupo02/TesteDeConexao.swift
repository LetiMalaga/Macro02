//
//  TesteDeConexao.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 21/11/24.
//

import Foundation
import WatchConnectivity

class TesteDeConexao: UIViewController{
    
    func configuraConexao(){
        let session = WCSession.default
        session.delegate = self
        session.activateSession()
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
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        <#code#>
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        <#code#>
    }
    
    func isEqual(_ object: Any?) -> Bool {
        <#code#>
    }
    
    var hash: Int {
        <#code#>
    }
    
    var superclass: AnyClass? {
        <#code#>
    }
    
    func `self`() -> Self {
        <#code#>
    }
    
    func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
        <#code#>
    }
    
    func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
        <#code#>
    }
    
    func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
        <#code#>
    }
    
    func isProxy() -> Bool {
        <#code#>
    }
    
    func isKind(of aClass: AnyClass) -> Bool {
        <#code#>
    }
    
    func isMember(of aClass: AnyClass) -> Bool {
        <#code#>
    }
    
    func conforms(to aProtocol: Protocol) -> Bool {
        <#code#>
    }
    
    func responds(to aSelector: Selector!) -> Bool {
        <#code#>
    }
    
    var description: String {
        <#code#>
    }
    
    
}
