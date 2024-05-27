//
//  RecordingView.swift
//  UProtect
//
//  Created by Simone Sarnataro on 23/05/24.
//

import SwiftUI

struct RecordingView: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        NavigationView {
            VStack {
//                RecordingsList(audioRecorder: audioRecorder)
                
//                if audioRecorder.recording == false {
//                    Button(action: {self.audioRecorder.startRecording()}) {
//                        Image(systemName: "circle.fill")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 70, height: 70)
//                            .clipped()
//                            .foregroundColor(.red)
//                            .padding(.bottom, 40)
//                    }
//                } else {
//                    Button(action: {self.audioRecorder.stopRecording()}) {
//                        Image(systemName: "stop.fill")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 70, height: 70)
//                            .clipped()
//                            .foregroundColor(.red)
//                            .padding(.bottom, 40)
//                    }
//                }
            }
            .navigationBarTitle("Voice Recorder")
        }
    }
}

struct ContentView_Previews89: PreviewProvider {
    static var previews: some View {
        RecordingView(audioRecorder: AudioRecorder())
    }
}
