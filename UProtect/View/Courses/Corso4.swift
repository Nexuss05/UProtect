//
//  Corso4.swift
//  UProtect
//
//  Created by Andrea Romano on 07/06/24.
//

import SwiftUI

struct Corso4: View {
    @Binding var course: Course
    @AppStorage("ButtonsLevel4") private var activeButtonsData: Data = Data()
    @State private var activeButtons: [Bool] = [true, false, false, false, false, false]
    @State private var isDetailViewPresented: Bool = false
    @State private var currentDetailIndex: Int = 0
    
    let detailData = [
        DetailData(view: AnyView(Course401())),
        DetailData(view: AnyView(Course402())),
        DetailData(view: AnyView(Course403())),
        DetailData(view: AnyView(Course404())),
        DetailData(view: AnyView(Course405()))
    ]
    
    init(course: Binding<Course>) {
        _course = course
        if let decoded = try? JSONDecoder().decode([Bool].self, from: activeButtonsData), !decoded.isEmpty {
            _activeButtons = State(initialValue: decoded)
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 50) {
                LevelBar(progress: completionPercentage(activeButtons))
                    .frame(height: 10)
                    .padding(.horizontal)
                ForEach(0..<5) { index in
                    if index < activeButtons.count {
                        if activeButtons[index] {
                            Button(action: {
                                currentDetailIndex = index
                                isDetailViewPresented = true
                            }) {
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
            .padding(.top, 20)
        }
        .fullScreenCover(isPresented: $isDetailViewPresented) {
            DetailView(activeButtons: $activeButtons, currentIndex: currentDetailIndex, activeButtonsData: $activeButtonsData, detailData: detailData[currentDetailIndex])
        }
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

struct LevelButtonView4: View {
    var isActive: Bool
    
    var body: some View {
        if isActive {
            ZStack {
                Ellipse()
                    .frame(width: 60, height: 50)
                    .foregroundStyle(CustomColor.orange)
                    .padding(.top, 10)
                Ellipse()
                    .frame(width: 60, height: 50)
                    .foregroundStyle(Color.white)
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

struct DetailView4: View {
    @Binding var activeButtons: [Bool]
    var currentIndex: Int
    @Binding var activeButtonsData: Data
    var detailData: DetailData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(CustomColor.orange)
                            Text("Back")
                                .foregroundStyle(CustomColor.orange)
                                .padding(.trailing, 5)
                        }
                    }
                    .padding()
                    Spacer()
                }.padding(.top, 50)
                ScrollView {
                    VStack {
                        detailData.view
                        Button(action: {
                            if currentIndex + 1 < activeButtons.count {
                                activeButtons[currentIndex + 1] = true
                                saveActiveButtons()
                            }
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Completato")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(color: .gray, radius: 5, x: 0, y: 2)
                                .padding(.vertical, 30)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .ignoresSafeArea()
        }
    
    private func saveActiveButtons() {
        if let encoded = try? JSONEncoder().encode(activeButtons) {
            activeButtonsData = encoded
        }
    }
}

struct DetailData4 {
    var view: AnyView
}

struct LevelBar4: View {
    var progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                
                Rectangle()
                    .frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(CustomColor.orange)
            }
        }
    }
}

