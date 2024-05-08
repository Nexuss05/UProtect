//
//  SettingsView.swift
//  Toothless
//
//  Created by Simone Sarnataro on 29/02/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var circleColor: Color = UserDefaultsManager.loadCircleColor() ?? Color.red
    @State var url = URL(string: "https://www.iubenda.com/privacy-policy/49969320")
    
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
                                Text("SS")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }.accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: -2.0){
                                Text("Simone Sarnataro")
                                    .fontWeight(.medium)
                                Text("+39 3716703252")
                                    .font(.subheadline)
                            }
                        }.accessibilityElement(children: .combine)
                    }
                    
                    Section(header: Text("System")){
                        NavigationLink {
                            GoalView()
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
                            
                        } label: {
                            Text("Recordings")
                        }
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
            }
        }
    }
}

struct UserDefaultsManager {
    static func loadCircleColor() -> Color? {
        if let savedColorData = UserDefaults.standard.data(forKey: "circleColor"),
           let savedColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedColorData) as? Color {
            return savedColor
        }
        return nil
    }
    
    static func saveCircleColor(_ color: Color) {
        if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) {
            UserDefaults.standard.set(colorData, forKey: "circleColor")
        }
    }
}

#Preview {
    SettingsView()
}
