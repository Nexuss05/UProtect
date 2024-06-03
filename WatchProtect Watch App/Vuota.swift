//
//  Vuota.swift
//  WatchProtect Watch App
//
//  Created by Simone Sarnataro on 03/06/24.
//

import SwiftUI

struct Vuota: View {
    var body: some View {
        ZStack {
            CustomColor.orangeBackground
            Text("Coming soon")
                .font(.largeTitle)
                .fontWeight(.semibold)
            .foregroundColor(Color("CustomOrange"))
        }.ignoresSafeArea()
    }
}

#Preview {
    Vuota()
}
