//  ContentView.swift
//  UProtect
//
//  Created by Matteo Cotena on 23/05/24.
//

import SwiftUI
import ContactsUI
import CoreLocation
import SwiftData

let backgroundColor = Color.init(white: 0.92)

struct ContentView: View {
    @State private var selectedContacts: [SerializableContact] = UserDefaults.standard.fetchContacts(forKey: "selectedContacts") ?? []
    @State private var isShowingContactsPicker = false
    @State var locationManager = LocationManager()
    let vonage = Vonage(apiKey: "7274c9fa", apiSecret: "hBAgiMnvBqIJQ4Ud")
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var selectedTab = 2
    @Namespace private var namespace
    @StateObject private var vm = CloudViewModel()
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer: AudioPlayer
    
    var body: some View {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        
        GeometryReader { geometry in
            VStack {
                TabView(selection: $selectedTab) {
                    TipsView(timerManager: timerManager)
                        .tabItem {
                            Label("Tips", systemImage: "brain.head.profile.fill")
                        }
                        .tag(0)
                    
                    if locationManager.isAuthorized {
                        MapView(selectedPage: .constant(0))
                            .tabItem {
                                Label("Map", systemImage: "map.fill")
                            }
                            .tag(1)
                    } else {
                        NoLocationView()
                            .tabItem {
                                Label("Map", systemImage: "map.fill")
                            }
                            .tag(1)
                    }
                    TimerView(timerManager: timerManager, selectedContacts: self.$selectedContacts)
                        .tabItem {
                            Label("Status", systemImage: "exclamationmark.triangle.fill")
                        }
                        .tag(2)
                    ContactsView(selectedContacts: $selectedContacts, isShowingContactsPicker: $isShowingContactsPicker, showAlert: $showAlert, alertMessage: $alertMessage)
                        .sheet(isPresented: $isShowingContactsPicker) {
                            ContactsPicker(isPresented: self.$isShowingContactsPicker, selectedContacts: self.$selectedContacts)
                        }
                        .tabItem {
                            Label("Contacts", systemImage: "person.circle.fill")
                        }
                        .tag(3)
                    
                    SettingsView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                        .tag(4)
                }
                .accentColor(timerManager.isActivated ? CustomColor.redBackground : CustomColor.orange)
                .onChange(of: selectedTab) { _ in
                    feedbackGenerator.impactOccurred()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            .ignoresSafeArea()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Messaggio"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                for _ in 0..<3 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        vm.fetchUserInfo()
                    }
                }
                TimeManager.shared.syncTokens()
            }
        }
    }
}

struct CustomColor {
    static let orange = Color("CustomOrange")
    static let orangeBackground = Color("OBackground")
    static let redBackground = Color("RBackground")
    static let mapButton = Color("MapButton")
    static let gray = Color("lightGray")
    static let ocra = Color("CustomOcra")
}

extension UITabBar {
    static func setCustomAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct ContentView_Previews3: PreviewProvider {
    static var previews: some View {
        let timerManager = TimerManager()
        return ContentView(timerManager: timerManager, audioRecorder: AudioRecorder(), audioPlayer: AudioPlayer())
    }
}
