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
    
//    func startPlayback(audio: URL) {
//        let playbackSession = AVAudioSession.sharedInstance()
//        
//        do {
//            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
//        } catch {
//            print("Playing over the device's speakers failed")
//        }
//        
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: audio)
//            audioPlayer.delegate = self
//            audioPlayer.play()
//            isPlaying = true
//            startTimer()
//        } catch {
//            print("Playback failed.")
//        }
//    }
    
    func startPlayback(audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            // Set the audio session category to play and record
            try playbackSession.setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .defaultToSpeaker])
            
            // Activate the audio session
            try playbackSession.setActive(true)
            
            // Check the current route to determine if headphones or Bluetooth devices are connected
            let currentRoute = playbackSession.currentRoute
            let hasHeadphonesOrBluetooth = currentRoute.outputs.contains {
                $0.portType == .headphones || $0.portType == .bluetoothA2DP || $0.portType == .bluetoothLE || $0.portType == .bluetoothHFP
            }
            
            // If headphones or Bluetooth devices are connected, do not force output to speaker
            if !hasHeadphonesOrBluetooth {
                try playbackSession.overrideOutputAudioPort(.speaker)
            } else {
                try playbackSession.overrideOutputAudioPort(.none)
            }
        } catch {
            print("Failed to set up playback session: \(error)")
            return
        }
        
        do {
            // Initialize the audio player and start playback
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
            startTimer()
        } catch {
            print("Playback failed: \(error)")
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
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateProgress()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateProgress() {
        guard let player = audioPlayer else { return }
        playbackProgress = player.currentTime / player.duration
    }
}
