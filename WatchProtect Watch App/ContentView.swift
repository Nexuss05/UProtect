//
//  ContentView.swift
//  WatchProtect Watch App
//
//  Created by Matteo Cotena on 24/05/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            VStack{
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 120)
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 55, height: 50)
                    .foregroundColor(.red)
                    .opacity(1)
            }
            .offset(CGSize(width: -10, height: 0))
            VStack {
                Text("TAP")
                    .foregroundStyle(.red)
                    .fontWeight(.bold)
                    .font(.title)
                Text("to receive help")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .multilineTextAlignment(.center)
        }
    }
}

//#Preview {
//    ContentView()
//}
