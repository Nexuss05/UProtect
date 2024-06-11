//
//  RecordingList.swift
//  UProtect
//
//  Created by Simone Sarnataro on 23/05/24.
//
import SwiftUI

struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    @State private var searchText = ""
    let deletionTimeInterval: TimeInterval = 10080 * 60
    
//    @State private var currentlyPlayingURL: URL?
    @State private var currentlyPlayingURL: URL? = nil

    
    var filteredRecordings: [Recording] {
        if searchText.isEmpty {
            return audioRecorder.recordings.sorted(by: { $0.createdAt > $1.createdAt })
        } else {
            return audioRecorder.recordings.filter { $0.fileURL.lastPathComponent.contains(searchText) }.sorted(by: { $0.createdAt > $1.createdAt })
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                VStack(alignment: .leading) {
                    Text("Recordings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                        .padding(.bottom, -2.5)
                    SearchBar(text: $searchText)
                    List {
                        ForEach(filteredRecordings, id: \.createdAt) { recording in
                            RecordingRow(audioURL: recording.fileURL, createdAt: recording.createdAt, audioRecorder: audioRecorder, audioPlayer: audioPlayer, currentlyPlayingURL: $currentlyPlayingURL)
                        }
                        .onDelete(perform: delete)
                    }
                    .background(CustomColor.orangeBackground)
                    .scrollContentBackground(.hidden)
                }
                .padding(.top, -40)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            audioRecorder.audioPlayer = audioPlayer
        }
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(filteredRecordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }

}

struct RecordingRow: View {
    
    var audioURL: URL
    var createdAt: Date
    var audioRecorder: AudioRecorder
    
    @ObservedObject var audioPlayer: AudioPlayer
    
    @Binding var currentlyPlayingURL: URL?
    var isCurrentlyPlaying: Bool {
        currentlyPlayingURL == audioURL
    }
    
    func share() {
        let activityViewController = UIActivityViewController(activityItems: [audioURL], applicationActivities: nil)
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            print("Errore: impossibile ottenere il root view controller")
            return
        }
        rootViewController.present(activityViewController, animated: true, completion: nil)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(audioURL.lastPathComponent)")
                        .font(.headline)
                    Text("\(formattedDate(date: createdAt))")
                        .font(.subheadline)
                }.accessibilityElement(children: .combine)
                Spacer()
                Menu {
                    Button(action: {
                        share()
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
            }
            HStack {
                ZStack{
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                        .opacity(0)
//                    if !isCurrentlyPlaying || audioPlayer.isPlaying == false {
//                        Button(action: {
//                            self.audioPlayer.startPlayback(audio: self.audioURL)
//                            currentlyPlayingURL = audioURL
//                        }) {
//                            Image(systemName: "play.circle")
//                                .imageScale(.large)
//                        }
//                    } else {
//                        Button(action: {
//                            self.audioPlayer.stopPlayback()
//                            currentlyPlayingURL = nil
//                        }) {
//                            Image(systemName: "stop.fill")
//                                .imageScale(.large)
//                        }
//                    }
                    if currentlyPlayingURL != audioURL || audioPlayer.isPlaying == false {
                        Button(action: {
                            self.audioPlayer.startPlayback(audio: self.audioURL)
                            currentlyPlayingURL = audioURL
                        }) {
                            Image(systemName: "play.circle")
                                .imageScale(.large)
                        }
                    } else {
                        Button(action: {
                            self.audioPlayer.stopPlayback()
                            currentlyPlayingURL = nil
                        }) {
                            Image(systemName: "stop.fill")
                                .imageScale(.large)
                        }
                    }
                }
//                Bar(progress: isCurrentlyPlaying ? audioPlayer.playbackProgress : 0)
//                    .frame(height: 5)
                Slider(value: isCurrentlyPlaying ? Binding<Double>(
                                get: { audioPlayer.playbackProgress },
                                set: { _ in }
                            ) : .constant(0), in: 0...1)
            }
            .padding(.top)
        }
        .frame(height: 100)
        .onAppear {
            startDeletionTimer()
        }
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, HH:mm"
        return formatter.string(from: date)
    }
    
    func startDeletionTimer() {
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if Date().timeIntervalSince(createdAt) >= 10080 * 60 {
                self.audioRecorder.deleteRecording(urlsToDelete: [self.audioURL])
                timer.invalidate()
            }
        }
    }
}

struct SearchBar: UIViewRepresentable {
    
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

//struct Bar: View {
//    var progress: Double
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack(alignment: .leading) {
//                Rectangle()
//                    .frame(width: geometry.size.width, height: geometry.size.height)
//                    .opacity(0.3)
//                    .foregroundColor(.gray)
//                
//                Rectangle()
//                    .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: geometry.size.height)
//                    .foregroundColor(CustomColor.orange)
//                    .animation(.linear, value: progress)
//            }
//            .cornerRadius(45.0)
//        }
//    }
//}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder(), audioPlayer: AudioPlayer())
    }
}
