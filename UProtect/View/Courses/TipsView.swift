//
//  TipsView.swift
//  UProtect
//
//  Created by Simone Sarnataro on 14/06/24.
//

import SwiftUI

struct TipsView: View {
    
    @State var scrolled: Int = 0
    @State var tips: [Tip] = [
        
        Tip(id: 0, categoria: "pollo", titolo: "sto cazzo", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn"),
        Tip(id: 1, categoria: "pollo2", titolo: "sto cazzo1", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn"),
        Tip(id: 2, categoria: "pollo3", titolo: "sto cazzo2", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn"),
        Tip(id: 3, categoria: "pollo4", titolo: "sto cazzo3", corpo: "sdghajhdsgalidubebtuytckuyat dfsbkfjbsdkjfhsdjkdfhksjfhdskjfbcsmcn")
        
    ]
    
    func calculateWidth() -> CGFloat{
        let screen = UIScreen.main.bounds.width - 30
        let width = screen - (2*32.5)
        return width
    }
    
    var body: some View {
        ZStack {
            CustomColor.orange
            ZStack{
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
                    }.padding(.top, 100)
                    VStack {
//                        Card(titolo: tip.titolo, testo: tip.corpo)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.white)
                                .frame(width: calculateWidth(), height: (UIScreen.main.bounds.height / 2) - CGFloat((tip.id - scrolled) * 50))
                                .offset(x: tip.id - scrolled <= 2 ? CGFloat((tip.id - scrolled) * 10) : 1)
                            .opacity(1.0 - Double(tip.id - scrolled) * 0.2)
                            if tip.id == scrolled{
                                VStack(alignment: .center){
                                    HStack {
                                        Text(tip.titolo)
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                        Spacer()
                                    }.padding(.horizontal)
                                        .padding(.top, 40)
                                        .padding(.bottom, 20)
                                    HStack {
                                        Text(tip.corpo)
                                            .font(.title3)
                                            .foregroundColor(CustomColor.gray)
                                            .lineSpacing(15)
                                        Spacer()
                                    }.padding(.horizontal)
                                    Spacer()
                                    HStack(alignment: .bottom){
                                        Image(systemName: "arrow.left")
                                        Text("swipe left to read more")
                                    }.foregroundStyle(CustomColor.orange)
                                        .padding(.bottom)
                                }.frame(width: 275, height: 400)
                            }
                        }
                    }.offset(x: tip.offset)
                        .gesture(DragGesture().onChanged({ value in
                            if tip.id == scrolled {
                                withAnimation{
                                    if value.translation.width < 0 && tip.id != tips.last!.id{
                                        tips[tip.id].offset = value.translation.width
                                    } else {
                                        if tip.id > 0{
                                            tips[tip.id - 1].offset = -(calculateWidth() + 60) + value.translation.width
                                        }
                                    }
                                }
                            }
                        }).onEnded({ value in
                            if tip.id == scrolled {
                                withAnimation{
                                    if value.translation.width < 0 {
                                        if -value.translation.width > 180 && tip.id != tips.last!.id {
                                            tips[tip.id].offset = -(calculateWidth() + 60)
                                            scrolled += 1
                                        } else {
                                            tips[tip.id].offset = 0
                                        }
                                    } else {
                                        if tip.id > 0 {
                                            if value.translation.width > 180 {
                                                tips[tip.id - 1].offset = 0
                                                scrolled -= 1
                                            } else {
                                                tips[tip.id].offset = -(calculateWidth() + 60)
                                            }
                                        }
                                    }
                                }
                            }
                        }))
                }
            }/*.frame(height: UIScreen.main.bounds.height / 1.8)*/
        }.ignoresSafeArea()
    }
}

#Preview {
    TipsView()
}
