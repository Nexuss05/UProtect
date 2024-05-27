//
//  ContentView.swift
//  UProtect
//
//  Created by Matteo Cotena on 03/05/24.
//

import SwiftUI
import ContactsUI
import CoreLocation
import SwiftData

let backgroundColor = Color.init(white: 0.92)

struct ContentView: View {
    @State private var selectedContacts: [SerializableContact] = UserDefaults.standard.fetchContacts(forKey: "selectedContacts") ?? []
    @State private var isShowingContactsPicker = false
    @StateObject private var locationManager = LocationManager()
    let vonage = Vonage(apiKey: "7274c9fa", apiSecret: "hBAgiMnvBqIJQ4Ud")
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var selectedTab: Tab = .danger
    @Namespace private var namespace
    
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var audioRecorder: AudioRecorder
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                switch selectedTab {
                case .course:
//                    RegistrationView(timerManager: timerManager, audioRecorder: audioRecorder)
                    CoursesView()
                case .map:
                    Text("Contenuto della mappa")
                        .padding(.top, 100)
                    //                    LocationFinder()
                case .danger:
                    TimerView(timerManager: timerManager, audioRecorder: audioRecorder)
                    //CompleteTimer()
                case .contact:
                    ContactsView(selectedContacts: $selectedContacts, isShowingContactsPicker: $isShowingContactsPicker, showAlert: $showAlert, alertMessage: $alertMessage)
                        .sheet(isPresented: $isShowingContactsPicker) {
                            ContactsPicker(isPresented: self.$isShowingContactsPicker, selectedContacts: self.$selectedContacts)
                        }
                    
                case .settings:
                    SettingsView(audioRecorder: audioRecorder)
                }
            }
            //            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            .ignoresSafeArea()
            .overlay(
                TabBarView(selectedTab: $selectedTab, namespace: namespace)
                //                    .frame(height: 70)
                //                    .padding(.bottom, 10)
                //                    .background(Color.white)
                //                    .edgesIgnoringSafeArea(.bottom)
                //                    .frame(width: geometry.size.width, height: 70)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 6)
                
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Messaggio"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
}

struct CustomColor {
    static let orange = Color("CustomOrange")
    static let orangeBackground = Color("OBackground")
    static let redBackground = Color("RBackground")
}

enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case course, map, danger, contact, settings
    
    internal var id: Int { rawValue }
    
    var icon: String {
        switch self {
        case .course:
            return "books.vertical.fill"
        case .map:
            return "map.fill"
        case .danger:
            return "exclamationmark.triangle.fill"
        case .contact:
            return "person.circle.fill"
        case .settings:
            return "gear"
        }
    }
    
    var title: String {
        switch self {
        case .course:
            return "Course"
        case .map:
            return "Map"
        case .danger:
            return "Danger"
        case .contact:
            return "Contact"
        case .settings:
            return "Settings"
        }
    }
    
    var color: Color {
        switch self {
        case .course:
            return .indigo
        case .map:
            return .pink
        case .danger:
            return .orange
        case .contact:
            return .teal
        case .settings:
            return .blue
        }
    }
}


struct ContentView_Previews3: PreviewProvider {
    static var previews: some View {
        let timerManager = TimerManager()
        return ContentView(timerManager: timerManager, audioRecorder: AudioRecorder())
    }
}
