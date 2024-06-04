//
//  Corso2.swift
//  UProtect
//
//  Created by Simone Sarnataro on 05/06/24.
//

import SwiftUI

struct Corso2: View {
    @AppStorage("ButtonsLevel2") private var activeButtonsData: Data = Data()
    @State private var activeButtons: [Bool] = [true, false, false, false, false]
    
    let detailData = [
        DetailData(text: "6"),
        DetailData(text: "7"),
        DetailData(text: "8"),
        DetailData(text: "9"),
        DetailData(text: "10")
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

#Preview {
    Corso2()
}
