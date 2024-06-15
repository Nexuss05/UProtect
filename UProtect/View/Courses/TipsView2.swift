//
//  TipsView2.swift
//  UProtect
//
//  Created by Simone Sarnataro on 15/06/24.
//

import SwiftUI

struct TipsView2: View {
    
    @State var scrolled: Int = 0
    @State var tips: [Tip] = [
        Tip(id: 0, categoria: "pollo", titolo: "sto cazzo", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn"),
        Tip(id: 1, categoria: "pollo2", titolo: "sto cazzo1", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn"),
        Tip(id: 2, categoria: "pollo3", titolo: "sto cazzo2", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn"),
        Tip(id: 3, categoria: "pollo4", titolo: "sto cazzo3", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn"),
        Tip(id: 4, categoria: "poll5", titolo: "sto cazzo4", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn"),
        Tip(id: 5, categoria: "pollo6", titolo: "sto cazzo5", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn"),
        Tip(id: 6, categoria: "pollo7", titolo: "sto cazzo6", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn"),
        Tip(id: 7, categoria: "pollo8", titolo: "sto cazzo7", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn"),
        Tip(id: 8, categoria: "pollo9", titolo: "sto cazzo8", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn"),
        Tip(id: 9, categoria: "pollo10", titolo: "sto cazzo9", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn"),
        Tip(id: 10, categoria: "pollo11", titolo: "sto cazzo10", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn"),
        Tip(id: 11, categoria: "pollo12", titolo: "sto cazzo11", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn")
    ]
    
    func calculateWidth() -> CGFloat {
        let screen = UIScreen.main.bounds.width - 30
        let width = screen - (2 * 32.5)
        return width
    }
    
    var body: some View {
        ZStack {
            CustomColor.orange
                .ignoresSafeArea()
            
            ZStack {
                ForEach(tips.reversed()) { tip in
                    VStack{
                        HStack {
                            Text("Tips & Tricks")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                        }.padding(.horizontal, 45)
                        if tip.id == scrolled{
                            HStack {
                                Text(tip.categoria)
                                    .font(.title)
                                    .fontWeight(.bold)
                                Spacer()
                            }.padding(.horizontal, 45)
                        }
                        Spacer()
                    }.padding(.top, 50)
                    VStack {
                        Card(titolo: tip.titolo,
                             testo: tip.corpo,
                             symbol: tip.id == tips.last!.id ? "timer" : "arrow.left",
                             info: tip.id == tips.last!.id ? "wait until tomorrow for more tips" : "swipe left to read more")
                        .offset(x: CGFloat((tip.id - scrolled) * 10))
                        .opacity(Double(1.0 - CGFloat(tip.id - scrolled) * 0.6))
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    withAnimation {
                                        if tip.id == scrolled {
                                            if value.translation.width < 0 && tip.id != tips.last!.id{
                                                tips[tip.id].offset = value.translation.width
                                            }
                                        }
                                    }
                                })
                                .onEnded({ value in
                                    withAnimation {
                                        if tip.id == scrolled {
                                            if value.translation.width < 0 {
                                                if value.translation.width < -100 && tip.id != tips.last!.id {
                                                    tips[tip.id].offset = -(calculateWidth() + 60)
                                                    scrolled += 1
                                                } else {
                                                    tips[tip.id].offset = 0
                                                }
                                            } else {
                                                if tip.id != 0 {
                                                    tips[tip.id - 1].offset = 0
                                                    scrolled -= 1
                                                } else {
                                                    tips[tip.id].offset = 0
                                                }
                                            }
                                        }
                                    }
                                })
                        )
                    }.offset(x: tip.offset)
                }
            }
        }
    }
}

#Preview {
    TipsView2()
}
