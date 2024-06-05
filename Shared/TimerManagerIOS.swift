////
////  TimerManagerIOS.swift
////  UProtect
////
////  Created by Simone Sarnataro on 04/06/24.
////
//
//import WatchConnectivity
//
//extension TimeManager: WCSessionDelegate {
//    func setupWCSession() {
//        if WCSession.isSupported() {
//            let session = WCSession.default
//            session.delegate = self
//            session.activate()
//            syncTokensPeriodically()
//            syncDataPeriodically()
//        }
//    }
//    
//    func syncTokensPeriodically() {
//        let syncTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
//            self.syncTokens()
//        }
//        RunLoop.main.add(syncTimer, forMode: .common)
//    }
//    
//    func syncDataPeriodically() {
//        let syncTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
//            self.syncTokens()
//            self.syncName()
//            self.syncSurname()
//        }
//        RunLoop.main.add(syncTimer, forMode: .common)
//    }
//    
//    func syncTokens() {
//        if let savedTokens = UserDefaults.standard.stringArray(forKey: "tokens") {
//            for token in savedTokens{
//                print(token)
//                let message: [String: Any] = ["action": "tokens", "tokens": token]
//                WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
//                    print("Failed to send tokens: \(error)")
//                })
//            }
//        } else {
//            print("nessun token")
//        }
//    }
//    
//    func syncName() {
//        if let tokens = UserDefaults.standard.string(forKey: "firstName") {
//            print(tokens)
//            let message: [String: Any] = ["action": "firstName", "firstName": tokens]
//            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
//                print("Failed to send name: \(error)")
//            })
//        }
//    }
//    
//    func syncSurname() {
//        if let tokens = UserDefaults.standard.string(forKey: "lastName") {
//            print(tokens)
//            let message: [String: Any] = ["action": "lastName", "lastName": tokens]
//            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
//                print("Failed to send surname: \(error)")
//            })
//        }
//    }
//    
//    func syncActivation() {
//        if WCSession.default.isReachable {
//            let message: [String: Any] = ["action": "activation", "isActivated": isActivated]
//            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
//                print("Failed to activate: \(error)")
//            })
//        }
//    }
//    
//    func syncCircleAnimation() {
//        if WCSession.default.isReachable {
//            let message: [String: Any] = ["action": "circleAnimation"]
//            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
//                print("Failed to activate: \(error)")
//            })
//        }
//    }
//    
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        // Handle session activation
//    }
//    
//    func sessionDidBecomeInactive(_ session: WCSession) {
//        // Handle session inactivity
//    }
//    
//    func sessionDidDeactivate(_ session: WCSession) {
//        // Handle session deactivation
//        WCSession.default.activate()
//    }
//    
//    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
//        if let action = message["action"] as? String {
//            switch action {
//            case "start":
//                if let count = message["count"] as? Int {
//                    DispatchQueue.main.async {
//                        self.count = count
//                        self.startTimer()
//                    }
//                }
//            case "tick":
//                if let count = message["count"] as? Int {
//                    DispatchQueue.main.async {
//                        self.count = count
//                    }
//                }
//            case "stop":
//                DispatchQueue.main.async {
//                    self.stopTimer()
//                }
//            case "activation":
//                if let isActivated = message["isActivated"] as? Bool {
//                    DispatchQueue.main.async {
//                        self.isActivated = isActivated
//                    }
//                }
//            case "circleAnimation":
//                DispatchQueue.main.async {
//                    self.CircleAnimation()
//                }
//            default:
//                break
//            }
//        }
//    }
//}

import WatchConnectivity

extension TimeManager: WCSessionDelegate {
    func setupWCSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
//            syncTokensPeriodically()
            syncDataPeriodically()
        }
    }
    
//    func syncTokensPeriodically() {
//        let syncTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
//            self.syncTokens()
//        }
//        RunLoop.main.add(syncTimer, forMode: .common)
//    }
    
    func syncDataPeriodically() {
        let syncTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.syncTokens()
            self.syncName()
            self.syncSurname()
        }
        RunLoop.main.add(syncTimer, forMode: .common)
    }
    
    func syncTokens() {
        if let savedTokens = UserDefaults.standard.stringArray(forKey: "tokens") {
            for token in savedTokens {
                print("Sending token: \(token)")
                let message: [String: Any] = ["action": "tokens", "tokens": [token]]
                WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                    print("Failed to send tokens: \(error.localizedDescription)")
                })
            }
        } else {
            print("No tokens found")
        }
    }
    
    func syncName() {
        if let firstName = UserDefaults.standard.string(forKey: "firstName") {
            print("Sending first name: \(firstName)")
            let message: [String: Any] = ["action": "firstName", "firstName": firstName]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Failed to send first name: \(error.localizedDescription)")
            })
        }
    }
    
    func syncSurname() {
        if let lastName = UserDefaults.standard.string(forKey: "lastName") {
            print("Sending last name: \(lastName)")
            let message: [String: Any] = ["action": "lastName", "lastName": lastName]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Failed to send last name: \(error.localizedDescription)")
            })
        }
    }
    
    func syncActivation() {
        if WCSession.default.isReachable {
            let message: [String: Any] = ["action": "activation", "isActivated": isActivated]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Failed to activate: \(error.localizedDescription)")
            })
        }
    }
    
    func syncCircleAnimation() {
        if WCSession.default.isReachable {
            let message: [String: Any] = ["action": "circleAnimation"]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Failed to activate: \(error.localizedDescription)")
            })
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate, reactivating")
        WCSession.default.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let action = message["action"] as? String {
            switch action {
            case "activation":
                if let isActivated = message["isActivated"] as? Bool {
                    DispatchQueue.main.async {
                        self.isActivated = isActivated
                    }
                }
            case "circleAnimation":
                DispatchQueue.main.async {
                    self.CircleAnimation()
                }
            default:
                break
            }
        }
    }
}
