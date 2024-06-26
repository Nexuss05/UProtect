//
//  Card.swift
//  UProtect
//
//  Created by Simone Sarnataro on 14/06/24.
//

import SwiftUI

struct Card: View {
    
    var titolo: String
    var testo: String
    var symbol: String
    var info: String
    
    var body: some View {
        ZStack {
//            CustomColor.orange
//            LinearGradient(stops: [.init(color: CustomColor.orange, location: 0.25),.init(color: CustomColor.orangeBackground, location: 1) ],startPoint: .top, endPoint: .bottom)
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(.white)
                .frame(width: 300, height: 430)
            VStack(alignment: .center){
                HStack {
                    Text(titolo)
                        .font(.largeTitle)
                    .fontWeight(.bold)
                    Spacer()
                }.padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                ScrollView {
                    HStack {
                        Text(testo)
                            .font(.title3)
                            .foregroundColor(CustomColor.gray)
                            .lineSpacing(15)
                    }
                    Spacer()
                }.padding(.horizontal)
                Spacer()
                HStack(alignment: .center){
                    Image(systemName: symbol)
                    Text(info)
                }.foregroundStyle(CustomColor.orange)
                    .padding(.bottom)
            }.frame(width: 300, height: 400)
        }.ignoresSafeArea()
        
    }
}

#Preview {
    Card(titolo: "Carry Non-Violent Deterrents", testo: "Equip your child with bright or reflective clothing to increase visibility, especially in low-light conditions. Reflective patches or accessories on backpacks can also be effective.", symbol: "arrow.left", info: "swipe left to read more")
}
