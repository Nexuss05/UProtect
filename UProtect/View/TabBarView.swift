//
//  TabBarView.swift
//  UProtect
//
//  Created by Matteo Cotena on 03/05/24.
//

import Foundation
import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: Tab
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                .fill(.white)
                .shadow(color: .gray.opacity(0.4), radius: 20, x: 0, y: 20)
            
            TabsLayoutView(selectedTab: $selectedTab, namespace: namespace) // Passa il binding alla vista interna
            
            .padding(.bottom, 10)
        }
        .frame(height: 80, alignment: .center)
    }
}


struct TabsLayoutView: View {
    @Binding var selectedTab: Tab
    var namespace: Namespace.ID
    
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            ForEach(Tab.allCases) { tab in
                TabButton(tab: tab, selectedTab: $selectedTab, namespace: namespace)
                Spacer(minLength: 0)
            }
        }
    }
    
    
    
    private struct TabButton: View {
        let tab: Tab
        @Binding var selectedTab: Tab
        var namespace: Namespace.ID
        
        var body: some View {
            Button {
                withAnimation {
                    selectedTab = tab
                }
            } label: {
                ZStack {
                    if isSelected {
                        Circle()
                            .shadow(radius: 10)
                            .background {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .foregroundColor(backgroundColor)
                            }
                            .offset(y: -30)
                            .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                            .animation(.spring(), value: selectedTab)
                    }
                    VStack{
                        Image(systemName: tab.icon)
                            .font(.system(size: 23, weight: .semibold, design: .rounded))
                            .foregroundColor(isSelected ? .red : .gray)
                            .scaleEffect(isSelected ? 1 : 0.8)
                            .offset(y: isSelected ? -30 : 0)
                        Text(tab.title)
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundColor(isSelected ? .init(white: 0.9) : .gray)
                            .scaleEffect(isSelected ? 1 : 0.8)
                            .offset(y: isSelected ? -30 : 0)
                    }
                    //                        .animation(isSelected ? .spring(response: 0.5, dampingFraction: 0.3, blendDuration: 1) : .spring(), value: selectedTab)
                }
            }
            .buttonStyle(.plain)
        }
        
        private var isSelected: Bool {
            selectedTab == tab
        }
    }
}


struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selectedTab: .constant(.danger), namespace: Namespace().wrappedValue)
            .padding(.horizontal)
    }
}
