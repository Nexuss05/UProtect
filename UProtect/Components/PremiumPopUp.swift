//
//  PremiumPopUp.swift
//  UProtect
//
//  Created by Simone Sarnataro on 04/06/24.
//

import SwiftUI

struct PremiumPopUp: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 300, height: 200, alignment: .center)
                .foregroundStyle(.white)
            VStack(spacing: 20.0) {
                Text("Need more contacts?")
                    .font(.title2)
                    .fontWeight(.bold)
                HStack {
                    Text("1 year")
                        .foregroundStyle(CustomColor.orange)
                    Text("of premium")
                }
                
                Button{
                    //                    TimeManager.shared.syncTokens()
                    //                    TimeManager.shared.syncName()
                    //                    TimeManager.shared.syncSurname()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 125, height: 30, alignment: .center)
                            .foregroundStyle(CustomColor.orange)
                        Text("1.99€")
                            .foregroundStyle(.white)
                    }
                }.padding(.top, 20)
            }
        }
    }
}

#Preview {
    PremiumPopUp()
}
