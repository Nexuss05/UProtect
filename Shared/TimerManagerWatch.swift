////
////  TimerManagerWatch.swift
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
//    func syncStartTime() {
//        if WCSession.default.isReachable {
//            let message: [String: Any] = ["action": "start", "count": count]
//            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
//                print("Failed to send start time: \(error)")
//            })
//        }
//    }
//    
//    func syncTimerTick() {
//        if WCSession.default.isReachable {
//            let message: [String: Any] = ["action": "tick", "count": count]
//            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
//                print("Failed to send timer tick: \(error)")
//            })
//        }
//    }
//    
//    func syncStopTime() {
//        if WCSession.default.isReachable {
//            let message: [String: Any] = ["action": "stop"]
//            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
//                print("Failed to send stop time: \(error)")
//            })
//        }
//    }
//    
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        // Handle session activation
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
//            case "tokens":
//                if let tokens = message["tokens"] as? [String] {
//                    print("tokens: \(tokens)")
//                    UserDefaults.standard.set(tokens, forKey: "tokensOnWatch")
//                    if let savedTokens = UserDefaults.standard.stringArray(forKey: "tokensOnWatch") {
//                        print("tokens: \(savedTokens)")
//                    }
//                }
//                print("token arrivato")
//            case "firstName":
//                if let firstName = message["firstName"] as? String {
//                    UserDefaults.standard.set(firstName, forKey: "nameOnWatch")
//                    if let savedFirstName = UserDefaults.standard.string(forKey: "nameOnWatch") {
//                        print("name: \(savedFirstName)")
//                    }
//                }
//                print("first name received")
//            case "lastName":
//                if let lastName = message["lastName"] as? String {
//                    UserDefaults.standard.set(lastName, forKey: "surnameOnWatch")
//                    if let savedLastName = UserDefaults.standard.string(forKey: "surnameOnWatch") {
//                        print("surname: \(savedLastName)")
//                    }
//                }
//                print("last name received")
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
            case "tokens":
                if let tokens = message["tokens"] as? [String] {
                    print("Received tokens: \(tokens)")
                    UserDefaults.standard.set(tokens, forKey: "tokensOnWatch")
                    if let savedTokens = UserDefaults.standard.stringArray(forKey: "tokensOnWatch") {
                        print("Saved tokens on watch: \(savedTokens)")
                    }
                }
            case "firstName":
                if let firstName = message["firstName"] as? String {
                    print("Received first name: \(firstName)")
                    UserDefaults.standard.set(firstName, forKey: "nameOnWatch")
                    if let savedFirstName = UserDefaults.standard.string(forKey: "nameOnWatch") {
                        print("Saved first name on watch: \(savedFirstName)")
                    }
                }
            case "lastName":
                if let lastName = message["lastName"] as? String {
                    print("Received last name: \(lastName)")
                    UserDefaults.standard.set(lastName, forKey: "surnameOnWatch")
                    if let savedLastName = UserDefaults.standard.string(forKey: "surnameOnWatch") {
                        print("Saved last name on watch: \(savedLastName)")
                    }
                }
            default:
                break
            }
        }
    }
}
