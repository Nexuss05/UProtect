//
//  NoLocationView.swift
//  UProtect
//
//  Created by Simone Sarnataro on 31/05/24.
//

import SwiftUI

struct NoLocationView: View {
    @State var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            Image("l4")
            VStack {
                Text("Location Services")
                    .font(.title)
                    .fontWeight(.bold)
                Text("1. Tap the button below\n2. Go to Location\n3. Change the settings to \"While Using the App\"")
                    .frame(width: 300)
                    .padding(.top)
                    .padding(.bottom, 30)
                Button{
                    if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }label: {
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(CustomColor.orange)
                        .frame(width: 250, height: 50)
                        .overlay(
                            Text("Enable Location")
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                }
            }.padding(.top, 275)
        }
    }
}

#Preview {
    NoLocationView()
}
