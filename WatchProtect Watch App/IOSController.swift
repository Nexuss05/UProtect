//
//  IOSController.swift
//  WatchProtect Watch App
//
//  Created by Simone Sarnataro on 29/05/24.
//

import Foundation
import WatchConnectivity
import UIKit

class WatchController: NSObject, WCSessionDelegate {
    
    var session: WCSession
    
    init(session: WCSession = .default) {
        
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState:WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failerd: \(error.localizedDescription)")
            return
        }
        if WCSession.default.isReachable{
            print("Reachable")
        } else {
            print("Not reachable")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("received message: \(message)")
        DispatchQueue.main.async{
            if let value = message["iPhone"] as? String{
                UserDefaults.standard.set(value, forKey: "receivedDataFromiPhone")
            }
        }
    }
    
    
}

