//
//  Vuota.swift
//  UProtect
//
//  Created by Simone Sarnataro on 06/06/24.
//

import SwiftUI

struct Vuota: View {
    var body: some View {
        ZStack {
            CustomColor.orangeBackground
            Text("Coming soon")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(CustomColor.orange)
        }.ignoresSafeArea()
    }
}

#Preview {
    Vuota()
}
