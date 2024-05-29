//
//  AudioPlayer.swift
//  UProtect
//
//  Created by Simone Sarnataro on 23/05/24.
//

import Foundation
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var playbackProgress: Double = 0.0
    var timer: Timer?
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var audioPlayer: AVAudioPlayer!
    
    func startPlayback(audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
            startTimer()
        } catch {
            print("Playback failed.")
        }
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
        stopTimer()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
            stopTimer()
            playbackProgress = 0.0
        }
    }
    
    private func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.updateProgress()
//                print(self.playbackProgress)
            }
        }
        
        private func stopTimer() {
            timer?.invalidate()
            timer = nil
        }
        
        private func updateProgress() {
            guard let player = audioPlayer else { return }
            playbackProgress = player.currentTime / player.duration
        }
}
