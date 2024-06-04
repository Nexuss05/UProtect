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
    //    @Environment(LocationManager.self) var locationManager
    
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
        GeometryReader { geometry in
            VStack {
                TabView(selection: $selectedTab) { 
//                    CoursesView()
                    Vuota()
                        .tabItem {
                            Label("Courses", systemImage: "books.vertical.fill")
                        }
                        .tag(0)
                    
                    if locationManager.isAuthorized{
//                        Text("Mappa")
                        // la mappa è stata tolta perchè fa crashare la preview
                        MapView(selectedPage: .constant(0))
                            .tabItem {
                                Label("Map", systemImage: "map.fill")
                            }
                            .tag(1)
                    }else{
                        NoLocationView()
                            .tabItem {
                            Label("Map", systemImage: "map.fill")
                        }
                        .tag(1)
                    }
                    TimerView(timerManager: timerManager, audioRecorder: audioRecorder)
                        .tabItem {
                            Label("Status", systemImage: "exclamationmark.triangle.fill")
                        }
                        .tag(2)
                    ContactsView(selectedContacts: $selectedContacts, isShowingContactsPicker: $isShowingContactsPicker, showAlert: $showAlert, alertMessage: $alertMessage)
                        .sheet(isPresented: $isShowingContactsPicker) {
                            ContactsPicker(isPresented: self.$isShowingContactsPicker, selectedContacts: self.$selectedContacts)
                        }
                        .tabItem {
                            Label("Contact", systemImage: "person.circle.fill")
                        }
                        .tag(3)
                    
                    SettingsView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                        .tag(4)
                }
                .accentColor(timerManager.isActivated ? CustomColor.redBackground : CustomColor.orange)
                //                .background(Color.orange)
            }
            //            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            .ignoresSafeArea()
            //            .overlay(
            //                TabBarView(selectedTab: $selectedTab, namespace: namespace)
            //                    .frame(height: 70)
            //                    .padding(.bottom, 10)
            //                    .background(Color.white)
            //                    .edgesIgnoringSafeArea(.bottom)
            //                    .frame(width: geometry.size.width, height: 70)
            //                    .position(x: geometry.size.width / 2, y: geometry.size.height - 6)
            
            //            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Messaggio"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear{
                vm.fetchUserInfo()
            }
        }
    }
    
}

struct CustomColor {
    static let orange = Color("CustomOrange")
    static let orangeBackground = Color("OBackground")
    static let redBackground = Color("RBackground")
}

extension UITabBar {
    static func setCustomAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
//        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct ContentView_Previews3: PreviewProvider {
    static var previews: some View {
        let timerManager = TimerManager()
        return ContentView(timerManager: timerManager, audioRecorder: AudioRecorder(), audioPlayer: AudioPlayer())
    }
}
