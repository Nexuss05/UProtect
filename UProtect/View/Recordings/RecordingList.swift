//
//  RecordingList.swift
//  UProtect
//
//  Created by Simone Sarnataro on 23/05/24.
//
import SwiftUI

struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    @State private var searchText = ""
    
    var filteredRecordings: [Recording] {
        if searchText.isEmpty {
            return audioRecorder.recordings
        } else {
            return audioRecorder.recordings.filter { $0.fileURL.lastPathComponent.contains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            List {
                ForEach(filteredRecordings, id: \.createdAt) { recording in
                    RecordingRow(audioURL: recording.fileURL, createdAt: recording.createdAt, audioRecorder: audioRecorder)
                }
                .onDelete(perform: delete)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

struct RecordingRow: View {
    
    var audioURL: URL
    var createdAt: Date
    var audioRecorder: AudioRecorder
    
    @ObservedObject var audioPlayer = AudioPlayer()
    @State private var isExpanded = false
    
    func share() {
        let activityViewController = UIActivityViewController(activityItems: [audioURL], applicationActivities: nil)
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            print("Errore: impossibile ottenere il root view controller")
            return
        }
        rootViewController.present(activityViewController, animated: true, completion: nil)
    }
    
    func saveToDevice() {
        let task = URLSession.shared.downloadTask(with: audioURL) { localURL, _, error in
            guard let localURL = localURL, error == nil else {
                print("Errore durante il download dell'audio: \(error?.localizedDescription ?? "Errore sconosciuto")")
                return
            }
            
            do {
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
                    .replacingOccurrences(of: "/", with: "-")
                    .replacingOccurrences(of: ",", with: "")
                    .replacingOccurrences(of: " ", with: "_at_")
                let savedURL = documentsURL.appendingPathComponent("\(timestamp).m4a")
                try FileManager.default.moveItem(at: localURL, to: savedURL)
                print("Audio salvato in: \(savedURL)")
            } catch {
                print("Errore durante il salvataggio dell'audio: \(error)")
            }
        }
        task.resume()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(audioURL.lastPathComponent)")
                        .font(.headline)
                    Text("\(formattedDate(date: createdAt))")
                        .font(.subheadline)
                }
                .onTapGesture {
                    if !isExpanded {
                        self.isExpanded.toggle()
                    }
                }
                Spacer()
                Menu {
                    Button(action: {
                        share()
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    Button(action: {
                        saveToDevice()
                    }) {
                        Label("Save", systemImage: "square.and.arrow.down")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
            }
            if isExpanded {
                AudioPlayerView(audioURL: audioURL, audioPlayer: audioPlayer)
                    .onDisappear {
                        self.audioPlayer.stopPlayback()
                    }
            }
        }
    }

    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, HH:mm"
        return formatter.string(from: date)
    }
}

//struct RecordingRow: View {
//
//    var audioURL: URL
//    var createdAt: Date
//
//    @ObservedObject var audioPlayer = AudioPlayer()
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text("\(audioURL.lastPathComponent)")
//                    .font(.headline)
//                Text("\(formattedDate(date: createdAt))")
//                    .font(.subheadline)
//            }
//            Spacer()
//            if audioPlayer.isPlaying == false {
//                Button(action: {
//                    self.audioPlayer.startPlayback(audio: self.audioURL)
//                }) {
//                    Image(systemName: "play.circle")
//                        .imageScale(.large)
//                }
//            } else {
//                Button(action: {
//                    self.audioPlayer.stopPlayback()
//                }) {
//                    Image(systemName: "stop.fill")
//                        .imageScale(.large)
//                }
//            }
//        }
//    }
//
//    func formattedDate(date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy, HH:mm"
//        return formatter.string(from: date)
//    }
//}

struct AudioPlayerView: View {
    
    var audioURL: URL
    @ObservedObject var audioPlayer: AudioPlayer
    
    var body: some View {
        VStack {
            Text("Timeline Here")
            HStack {
                Button(action: {
                    // Implement logic for rewinding
                }) {
                    Image(systemName: "backward.fill")
                        .imageScale(.large)
                }
                Spacer()
                if audioPlayer.isPlaying == false {
                    Button(action: {
                        self.audioPlayer.startPlayback(audio: self.audioURL)
                    }) {
                        Image(systemName: "play.circle")
                            .imageScale(.large)
                    }
                } else {
                    Button(action: {
                        self.audioPlayer.stopPlayback()
                    }) {
                        Image(systemName: "stop.fill")
                            .imageScale(.large)
                    }
                }
                Spacer()
                Button(action: {
                    // Implement logic for fast forwarding
                }) {
                    Image(systemName: "forward.fill")
                        .imageScale(.large)
                }
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

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}
