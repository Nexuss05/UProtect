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
    @State private var circleColor: Color = UserDefaultsManager.loadCircleColor() ?? Color.red
    @State var url = URL(string: "https://www.iubenda.com/privacy-policy/49969320")
    @Query var userData: [Contacts]
    @ObservedObject var audioRecorder: AudioRecorder
    @StateObject private var vm = CloudViewModel()
    let numero = UserDefaults.standard.string(forKey: "phoneNumber") ?? "non disponibile"
    
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
                                Text("\(vm.firstName.prefix(1))\(vm.lastName.prefix(1))")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }.accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: -2.0){
                                Text("\(vm.firstName) \(vm.lastName)")
                                    .fontWeight(.medium)
                                Text("\(numero)")
                                    .font(.subheadline)
                            }
                        }.accessibilityElement(children: .combine)
                    }
                    Section(header: Text("System")){
                        NavigationLink {
                            GoalView()
                                .padding(.top, -50)
                        } label: {
                            Text("Change time")
                        }
                        
                        Button(action: {
                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }) {
                            HStack {
                                Text("Notification")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "arrow.up.forward")
                                    .foregroundStyle(CustomColor.orange)
                            }
                        }
                        
                        Button(action: {
                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }) {
                            HStack {
                                Text("Change Language")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "arrow.up.forward")
                                    .foregroundStyle(CustomColor.orange)
                            }
                        }
                    }
                    
                    Section(header: Text("Background Recordings")){
                        NavigationLink {
                            RecordingsList(audioRecorder: audioRecorder).ignoresSafeArea()
                        } label: {
                            Text("Recordings")
                        }.navigationViewStyle(StackNavigationViewStyle())
                    }
                    
                    Section(header: Text("Titolo")) {
                        Text("Onboarding")
                            .foregroundColor(.primary)
                        Text("Siri & Shortcuts")
                            .foregroundColor(.primary)
                        Text("Widgets")
                            .foregroundColor(.primary)
                    }
                    
                    Section(header: Text("About")){
                        ShareLink(item: "https://testflight.apple.com/join/UjB0xSRP")
                            .foregroundColor(.primary)
                        HStack {
                            Link("Privacy Policy", destination: url!)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "arrow.up.forward")
                                .foregroundStyle(CustomColor.orange)
                        }.onTapGesture {
                            if let url = URL(string: "https://www.iubenda.com/privacy-policy/49969320") {
                                UIApplication.shared.open(url)
                            }
                        }
                        
                    }
                }
                .navigationTitle("Settings")
                .background(CustomColor.orangeBackground)
                .scrollContentBackground(.hidden)
            }.onAppear {
                vm.fetchUserInfo(number: numero) { fetchedFirstName, fetchedLastName, error in
                    DispatchQueue.main.async {
                        if let fetchedFirstName = fetchedFirstName, let fetchedLastName = fetchedLastName {
                            self.vm.firstName = fetchedFirstName
                            self.vm.lastName = fetchedLastName
                        } else {
                            print("Error fetching user info: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
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

struct ContentView_Previews88: PreviewProvider {
    static var previews: some View {
        SettingsView(audioRecorder: AudioRecorder())
    }
}
