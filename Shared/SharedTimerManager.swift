//
//  TimeManager.swift
//  UProtect
//
//  Created by Simone Sarnataro on 04/06/24.
//

import Foundation
import Combine
import UserNotifications
import SwiftUI

class TimeManager: NSObject, ObservableObject {
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
    @Published var to: CGFloat = 0
    @Published var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var timer: Timer?
    @State var dismissTimer: Timer?
    
    @Published var leftTime: Date = Date()
    static let shared = TimeManager()
    
    func Activation() {
        isActivated.toggle()
    }
    
    func CircleAnimation() {
        circleOpacity = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                if self.isActivated {
                    self.showCircle.toggle()
                    self.CircleAnimation()
                } else {
                    print("stop animazione cerchi")
                    self.showCircle = false
                    self.circleOpacity = false
                }
            }
        }
    }
}
