//
//  TimerManager.swift
//  UProtect
//
//  Created by Simone Sarnataro on 29/05/24.
//

import SwiftUI
import UserNotifications
import ActivityKit

class TimerManager: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var isActivated: Bool = false
    @Published var isPressed = false
    @Published var showCircle = false
    @Published var circleOpacity = false
    @Published var showMark: Bool = true
    @Published var canCancel: Bool = false
    
    @Published var start = false
    @Published var count = 300
    @Published var maxTime = 300
    @Published var to : CGFloat = 0
    @Published var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var timer: Timer?
    @State var dismissTimer: Timer?
    
    @Published var leftTime: Date = Date()
    
//    @Published var timerActivity: Activity<TimerActivityAttributes>?
    init() {
        //        updateCountFromLastCounter()
    }
    
    func Activation() {
        isActivated.toggle()
    }
    
    func startTimer() {
//        startTimerActivity()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            self.isPressed = false
            self.start = true
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                self?.timerTick()
            }
        }
    }
    
    private func timerTick() {
        guard count > 0 else {
            self.notify()
            stopTimer()
            showAlert = true
            dismissTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
                if !self.start{
                    print("Popup alert ignored for 10 seconds")
                    self.showAlert = false
                    self.showMark = true
                    self.CircleAnimation()
                    self.circleOpacity = true
                }
            }
//            endTimerActivity()
            return
        }
        count -= 1
        print("\(count)")
//        updateTimerActivity()
    }
    
    private func notify(){
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.subtitle = "Go back to the app to turn off the Supervision mode"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    var rotationAngle: Angle {
        let progress = 1 - to
        return .degrees(Double(progress) * 360 - 90)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        start = false
        updateCountFromLastCounter()
//        endTimerActivity()
    }
    
    func restartTimer() {
        stopTimer()
        startTimer()
    }
    
    var formattedTime: String {
        let minutes = count / 60
        let seconds = count % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func updateCountFromLastCounter() {
        if !start{
            count = maxTime
            print("count updated")
            updateProgress()
        }
    }
    
    func updateProgress(){
        self.to = CGFloat(self.count) / CGFloat(maxTime)
//        print("progess updated")
    }
    
    func CircleAnimation() {
        circleOpacity = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                if self.isActivated{
                    if self.isActivated{
                        self.showCircle.toggle()
                        self.CircleAnimation()
                    }else{
                        print("stop animazione cerchi")
                        self.showCircle = false
                        self.circleOpacity = false
                    }
                } else {
                    print("stop animazione cerchi")
                    self.showCircle = false
                    self.circleOpacity = false
                }
            }
        }
    }
}
