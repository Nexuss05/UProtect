//
//  UProtect.swift
//  UProtect
//
//  Created by Simone Sarnataro on 22/05/24.
//

import SwiftUI

struct UProtect: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var checkWelcomeScreen: Bool = false
    
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer: AudioPlayer
    
    var body: some View {
        VStack {
            if checkWelcomeScreen {
                ContentView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
            } else {
                WelcomeView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
            }
        }.onAppear {
            checkWelcomeScreen = isWelcomeScreenOver
        }
    }
}
