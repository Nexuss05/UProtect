////
////  WatchController.swift
////  UProtect
////
////  Created by Simone Sarnataro on 29/05/24.
////
//
//import Foundation
//import WatchConnectivity
//import UIKit
//
//class WatchController: UIViewController, WCSessionDelegate, ObservableObject {
//    
//    func sessionDidBecomeInactive(_ session: WCSession) {
//        
//    }
//    
//    func sessionDidDeactivate(_ session: WCSession) {
//        
//    }
//    
//    var session: WCSession!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        if WCSession.isSupported() {
//            session = WCSession.default
//            session.delegate = self
//            session.activate()
//            observeUserDefaults()
//            let array = ["fab87345bb174db9ad28cac9cc77c5c087d193e9a690553d7e812c37689ccbf0", "fab87345bb174db9ad28cac9cc77c5c087d193e9a690553d7e812c37689ccbf0", "fab87345bb174db9ad28cac9cc77c5c087d193e9a690553d7e812c37689ccbf0"]
//            sendArrayToWatch(array: array)
//        }
//    }
//    
//    func sendArrayToWatch(array: [String]) {
//            if WCSession.default.isReachable {
//                do {
//                    try WCSession.default.updateApplicationContext(["data": array])
//                    print("Array inviato all'app per Apple Watch")
//                } catch {
//                    print("Errore nell'invio dell'array: \(error.localizedDescription)")
//                }
//            }
//        }
//    
//    func observeUserDefaults() {
//        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange(_:)), name: UserDefaults.didChangeNotification, object: nil)
//    }
//
//    @objc func userDefaultsDidChange(_ notification: Notification) {
//        print("UserDefaults did change")
//        if let tokens = UserDefaults.standard.stringArray(forKey: "tokens") {
//            print("Tokens found in UserDefaults: \(tokens)")
//            sendTokensToWatch3("fab87345bb174db9ad28cac9cc77c5c087d193e9a690553d7e812c37689ccbf0")
//        } else {
//            print("Tokens not found in UserDefaults")
//        }
//    }
//
//    func sendTokensToWatch(_ tokens: [String]) {
//        print("Sending tokens to Watch: \(tokens)")
//        if let validSession = session, validSession.isReachable {
//            do {
//                let data = try NSKeyedArchiver.archivedData(withRootObject: tokens, requiringSecureCoding: true)
//                try validSession.updateApplicationContext(["tokens": data])
//                print("Tokens sent successfully to Watch")
//            } catch {
//                print("Failed to send tokens to Watch: \(error)")
//            }
//        } else {
//            print("Session not reachable")
//        }
//    }
//    
//    func sendTokensToWatch3(_ tokens: String) {
//        print("Sending tokens to Watch: \(tokens)")
//        if let validSession = session, validSession.isReachable {
//            do {
//                let data = try NSKeyedArchiver.archivedData(withRootObject: tokens, requiringSecureCoding: true)
//                try validSession.updateApplicationContext(["tokens": data])
//                print("Tokens sent successfully to Watch")
//            } catch {
//                print("Failed to send tokens to Watch: \(error)")
//            }
//        } else {
//            print("Session not reachable")
//        }
//    }
//
//    func session(_ session: WCSession, activationDidCompleteWith activationState:WCSessionActivationState, error: Error?) {
//        if let error = error {
//            print("WCSession activation failerd: \(error.localizedDescription)")
//            return
//        }
//        if WCSession.default.isReachable{
//            print("Reachable")
//        } else {
//            print("Not reachable")
//        }
//    }
//    
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        print("Received message: \(message)")
//        DispatchQueue.main.async{
//            if let tokens = message["tokens"] as? Data {
//                do {
//                    let decodedTokens = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(tokens) as? [String] ?? []
//                } catch {
//                    print("Failed to decode received tokens: \(error)")
//                }
//            }
//        }
//    }
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//}
//
//
