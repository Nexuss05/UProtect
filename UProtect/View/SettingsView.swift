//
//  SettingsView.swift
//  Toothless
//
//  Created by Simone Sarnataro on 29/02/24.
//

import Foundation
import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State private var circleColor: Color = UserDefaultsManager.loadCircleColor() ?? Color.red
    @State var url = URL(string: "https://www.iubenda.com/privacy-policy/49969320")
    @Query var userData: [Contacts]
    
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer: AudioPlayer
    @StateObject private var vm = CloudViewModel()
    
    let numero = UserDefaults.standard.string(forKey: "userNumber") ?? "non disponibile"
    let nome = UserDefaults.standard.string(forKey: "firstName") ?? "Name"
    let cognome = UserDefaults.standard.string(forKey: "lastName") ?? "Surname"
    
    @State var showOnBoarding: Bool = false
    @State var showWidget: Bool = false
    @State var showAlert: Bool = false
    @State var showAlert2: Bool = false
    @State var showAlert3: Bool = false
    @State var showReg: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    Section{
                        HStack(spacing: 25.0) {
                            ZStack {
                                Circle()
                                    .fill(circleColor)
                                    .frame(width: 35, height: 35)
                                Text("\(nome.prefix(1))\(cognome.prefix(1))")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }.accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: -2.0){
                                Text("\(nome) \(cognome)")
                                    .fontWeight(.medium)
                                Text("\(numero)")
                                    .font(.subheadline)
                            }
                        }.accessibilityElement(children: .combine)
                    }
                    Section(header: Text("FEATURES")){
                        NavigationLink {
                            GoalView(timerManager: timerManager)
                                .padding(.top, -50)
                        } label: {
                            Text("Change time")
                        }
                        NavigationLink {
                            RecordingsList(audioRecorder: audioRecorder, audioPlayer: audioPlayer).ignoresSafeArea()
                        } label: {
                            Text("Recordings")
                        }.navigationViewStyle(StackNavigationViewStyle())
                        
                        //                        Button(action: {
                        //                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                        //                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        //                            }
                        //                        }) {
                        //                            HStack {
                        //                                Text("Change Language")
                        //                                    .foregroundColor(.primary)
                        //                                Spacer()
                        //                                Image(systemName: "arrow.up.forward")
                        //                                    .foregroundStyle(CustomColor.orange)
                        //                            }
                        //                        }
                        //                        Button(action: {
                        //                            //bho
                        //                        }) {
                        //                            HStack {
                        //                                Text("Overcome Do Not Disturb")
                        //                                    .foregroundColor(.primary)
                        //                                Spacer()
                        //                                Image(systemName: "arrow.up.forward")
                        //                                    .foregroundStyle(CustomColor.orange)
                        //                            }
                        //                        }
                    }
                    
                    Section(header: Text("SETTINGS")){
                        Button(action: {
                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }) {
                            HStack {
                                Text("App preferences")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "arrow.up.forward")
                                    .foregroundStyle(CustomColor.orange)
                            }
                        }
                    }
                    
                    //                    Section(header: Text("ABOUT")) {
                    //                        Text("Siri & Shortcuts")
                    //                            .foregroundColor(.primary)
                    //                        Text("Widgets")
                    //                            .foregroundColor(.primary)
                    //                    }
                    
                    Section(header: Text("ABOUT")){
//                        HStack{
//                            Text("Onboarding")
//                                .foregroundColor(.primary)
//                            Spacer()
//                            Image(systemName: "chevron.right")
//                        }.onTapGesture {
//                            showOnBoarding.toggle()
//                        }
                        NavigationLink {
                            OnBoarding2(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer).ignoresSafeArea()
                        } label: {
                            Text("Onboarding")
                        }
                        HStack {
                            Link("Privacy Policy", destination: url!)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "arrow.up.forward")
                                .foregroundStyle(CustomColor.orange)
                        }.onTapGesture {
                            if let url = URL(string: "https://www.iubenda.com/privacy-policy/60037945") {
                                UIApplication.shared.open(url)
                            }
                        }
                        ShareLink(item: "https://testflight.apple.com/join/UjB0xSRP")
                            .foregroundColor(.primary)
                        
                    }
                    
                    Section{
                        Button{
                            showAlert.toggle()
                        } label: {
                            Text("Delete Account")
                                .foregroundStyle(CustomColor.redBackground)
                        }
                        Button{
                            showAlert3.toggle()
                        } label: {
                            Text("Log Out")
                                .foregroundStyle(CustomColor.redBackground)
                        }
                    }
                }
                .navigationTitle("Settings")
                .background(CustomColor.orangeBackground)
                .scrollContentBackground(.hidden)
                .fullScreenCover(isPresented: $showReg, content: {
                    RegistrationView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
                })
                .sheet(isPresented: $showOnBoarding, content: {
                    WelcomeView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
                        .alert("Try again later", isPresented: $showAlert2) {
                            Button("Ok") { }
                        }
                }).alert("Are you sure?", isPresented: $showAlert) {
                    Button("YES", role: .destructive) {
                        vm.deleteUser { success in
                            if success{
                                let fcmToken = UserDefaults.standard.string(forKey: "fcmToken")
                                if let bundleIdentifier = Bundle.main.bundleIdentifier {
                                    UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
                                }
                                if let token = fcmToken {
                                    UserDefaults.standard.set(token, forKey: "fcmToken")
                                }
                                isWelcomeScreenOver = false
                                showReg.toggle()
                            } else {
                                print("pollo")
                                showAlert2.toggle()
                            }
                        }
                    }
                    Button("NO", role: .cancel) { }
                }
                .alert("Are you sure?", isPresented: $showAlert) {
                    Button("YES", role: .destructive) {
                        let fcmToken = UserDefaults.standard.string(forKey: "fcmToken")
                        if let bundleIdentifier = Bundle.main.bundleIdentifier {
                            UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
                        }
                        if let token = fcmToken {
                            UserDefaults.standard.set(token, forKey: "fcmToken")
                        }
                        isWelcomeScreenOver = false
                        showReg.toggle()
                    }
                    Button("NO", role: .cancel) { }
                }
                .onAppear{
                    vm.fetchUserInfo()
                }
            }
        }
    }
}

struct UserDefaultsManager {
    static func loadCircleColor() -> Color? {
        if let savedColorData = UserDefaults.standard.data(forKey: "circleColor"),
           let savedColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: savedColorData) {
            return Color(savedColor)
        }
        return nil
    }
    
    static func saveCircleColor(_ color: Color) {
        if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) {
            UserDefaults.standard.set(colorData, forKey: "circleColor")
        }
    }
}

//struct ContentView_Previews88: PreviewProvider {
//    static var previews: some View {
//        SettingsView(audioRecorder: AudioRecorder())
//    }
//}
