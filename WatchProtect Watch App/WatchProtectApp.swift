//
//  WatchProtectApp.swift
//  WatchProtect Watch App
//
//  Created by Matteo Cotena on 24/05/24.
//

import SwiftUI
import WatchKit
import WatchConnectivity

@main
struct WatchProtect_Watch_AppApp: App {
//    @StateObject var timerManager = TimerManager()
//    @StateObject var audioRecorder = AudioRecorder()
    
    init() {
            TimeManager.shared.setupWCSession()
        }
    
    var body: some Scene {
        WindowGroup {
//            NewView()
//            TimerWatchView()
//            Vuota()
            ContentView()
        }
    }
}
