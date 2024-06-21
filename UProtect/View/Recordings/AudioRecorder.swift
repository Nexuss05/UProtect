//
//  AudioRecorder.swift
//  UProtect
//
//  Created by Simone Sarnataro on 23/05/24.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
import CoreLocation

struct Recording {
    let fileURL: URL
    let createdAt: Date
}

class AudioRecorder: NSObject, ObservableObject {
    
    static let shared = AudioRecorder()
    var audioPlayer: AudioPlayer?
    
    override init() {
        super.init()
        fetchRecording()
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    var userLocation: String?
    var locationManager = LocationManager()
    var recordings = [Recording]()
    
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func convertLatLongToAddress(latitude:Double,longitude:Double, completion: @escaping (String) -> Void){
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            if let street = placeMark.thoroughfare {
                print("mammt")
                print(street)
                completion(street)
            }
        })
        
    }
    
    func startRecording(lat: Double, long: Double) {
        var position = ""
        convertLatLongToAddress(latitude: lat, longitude: long){ street in
            print("street before: \(position)")
            position = street
            print("street sfter: \(position)")
            
            let recordingSession = AVAudioSession.sharedInstance()
            
            do {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
                try recordingSession.setActive(true)
            } catch {
                print("Failed to set up recording session")
            }
            
            let timestamp = Date().toString(dateFormat: "yyyyMMdd_HHmmss")
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentPath.appendingPathComponent("\(position)_\(timestamp)")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                self.audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                self.audioRecorder.record()
                self.recording = true
            } catch {
                print("Could not start recording")
            }
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        self.recording = false
        self.fetchRecording()
        print("Stop recording")
    }
    
    func fetchRecording() {
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getFileDate(for: audio))
            recordings.append(recording)
        }
        
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
        
        objectWillChange.send(self)
    }
    
//    func deleteRecording(urlsToDelete: [URL]) {
//
//        for url in urlsToDelete {
//            print(url)
//            if audioPlayer?.audioPlayer?.url == url && audioPlayer?.isPlaying == true {
//                audioPlayer?.stopPlayback()
//            }
//            do {
//                try FileManager.default.removeItem(at: url)
//            } catch {
//                print("File could not be deleted!")
//            }
//        }
//
//        fetchRecording()
//    }
    
    func deleteRecording(urlsToDelete: [URL]) {
        for url in urlsToDelete {
            if let index = recordings.firstIndex(where: { $0.fileURL == url }) {
                recordings.remove(at: index)
            }
            if let audioPlayer = audioPlayer, audioPlayer.audioPlayer?.url == url {
                audioPlayer.stopPlayback()
            }
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        objectWillChange.send(self)
    }
    
    func deleteAllRecordings() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try? fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        
        directoryContents?.forEach { url in
            do {
                try fileManager.removeItem(at: url)
            } catch {
                print("Could not delete file: \(url)")
            }
        }
        fetchRecording()
    }
    
    func getFileDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
           let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
}

extension Date {
    
    func toString(dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
