//
//  Corso1.swift
//  UProtect
//
//  Created by Simone Sarnataro on 01/06/24.
//
import SwiftUI

struct Corso1: View {
    @AppStorage("ButtonsLevel1") private var activeButtonsData: Data = Data()
    @State private var activeButtons: [Bool] = [true, false, false, false, false]
    
    let detailData = [
        DetailData(text: "strunz"),
        DetailData(text: "nella prossima c'è un segreto"),
        DetailData(text: "scherzetto"),
        DetailData(text: "nella prossima davvero c'è"),
        DetailData(text: "𓂺")
    ]
    
    init() {
        if let decoded = try? JSONDecoder().decode([Bool].self, from: activeButtonsData), !decoded.isEmpty {
            _activeButtons = State(initialValue: decoded)
        }
    }
    
    var body: some View {
//        NavigationView {
        ZStack {
            Color.white
            VStack(spacing: 50) {
                    LevelBar(progress: completionPercentage(activeButtons))
                        .frame(height: 10)
                        .padding(.horizontal)
                    ForEach(0..<5) { index in
                        if index < activeButtons.count {
                            if activeButtons[index] {
                                NavigationLink(destination: DetailView(activeButtons: $activeButtons, currentIndex: index, activeButtonsData: $activeButtonsData, detailData: detailData[index])) {
                                    LevelButtonView(isActive: activeButtons[index])
                                        .padding(index == 1 ? .leading : index == 3 ? .trailing : [], 150)
                                }
                            } else {
                                LevelButtonView(isActive: activeButtons[index])
                                    .padding(index == 1 ? .leading : index == 3 ? .trailing : [], 150)
                            }
                        }
                    }
            }
        }.ignoresSafeArea()
//        }
    }
    
    private func saveActiveButtons() {
        if let encoded = try? JSONEncoder().encode(activeButtons) {
            activeButtonsData = encoded
        }
    }
    
    private func completionPercentage(_ activeButtons: [Bool]) -> Double {
        let completedCount = activeButtons.filter { $0 }.count
        let totalCount = activeButtons.count
        return Double(completedCount) / Double(totalCount)
    }
}

struct LevelButtonView: View {
    @State private var tapped: Bool = false
    var isActive: Bool
    
    func tapAnimation() {
        tapped.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                self.tapped = false
            }
        }
    }
    
    var body: some View {
        if isActive {
            if !tapped {
                ZStack {
                    Ellipse()
                        .frame(width: 60, height: 50)
                        .foregroundStyle(CustomColor.orange)
                        .padding(.top, 10)
                    Ellipse()
                        .frame(width: 60, height: 50)
                        .foregroundStyle(CustomColor.orangeBackground)
                }.onTapGesture {
                    tapAnimation()
                }
            } else {
                Ellipse()
                    .frame(width: 60, height: 50)
                    .padding(.top, 10)
                    .foregroundStyle(CustomColor.orangeBackground)
            }
        } else {
            ZStack {
                Ellipse()
                    .frame(width: 60, height: 50)
                    .foregroundStyle(.black)
                    .padding(.top, 10)
                Ellipse()
                    .frame(width: 60, height: 50)
                    .foregroundStyle(.gray)
            }
        }
    }
}

struct DetailView: View {
    @Binding var activeButtons: [Bool]
    var currentIndex: Int
    @Binding var activeButtonsData: Data
    var detailData: DetailData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text(detailData.text)
                .padding()
            Button("Completato") {
                if currentIndex + 1 < activeButtons.count {
                    activeButtons[currentIndex + 1] = true
                    saveActiveButtons()
                }
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
    
    private func saveActiveButtons() {
        if let encoded = try? JSONEncoder().encode(activeButtons) {
            activeButtonsData = encoded
        }
    }
}

struct DetailData {
    var text: String
}

struct LevelBar: View {
    var progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                
                Rectangle()
                    .frame(width: min(CGFloat(progress)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(CustomColor.orange)
            }
        }
    }
}

struct Corso1_Previews: PreviewProvider {
    static var previews: some View {
        Corso1()
    }
}
