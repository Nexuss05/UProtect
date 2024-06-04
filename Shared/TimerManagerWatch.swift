//
//  TimerManagerWatch.swift
//  UProtect
//
//  Created by Simone Sarnataro on 04/06/24.
//

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
                print("Failed to activate: \(error)")
            })
        }
    }
    
    func syncCircleAnimation() {
        if WCSession.default.isReachable {
            let message: [String: Any] = ["action": "circleAnimation"]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Failed to activate: \(error)")
            })
        }
    }
    
    func syncStartTime() {
        if WCSession.default.isReachable {
            let message: [String: Any] = ["action": "start", "count": count]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Failed to send start time: \(error)")
            })
        }
    }
    
    func syncTimerTick() {
        if WCSession.default.isReachable {
            let message: [String: Any] = ["action": "tick", "count": count]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Failed to send timer tick: \(error)")
            })
        }
    }
    
    func syncStopTime() {
        if WCSession.default.isReachable {
            let message: [String: Any] = ["action": "stop"]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Failed to send stop time: \(error)")
            })
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle session activation
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let action = message["action"] as? String {
            switch action {
            case "start":
                if let count = message["count"] as? Int {
                    DispatchQueue.main.async {
                        self.count = count
                        self.startTimer()
                    }
                }
            case "tick":
                if let count = message["count"] as? Int {
                    DispatchQueue.main.async {
                        self.count = count
                    }
                }
            case "stop":
                DispatchQueue.main.async {
                    self.stopTimer()
                }
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
                    UserDefaults.standard.set(tokens, forKey: "tokensOnWatch")
                }
            default:
                break
            }
        }
    }
}
