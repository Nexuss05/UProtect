//
//  ContentView.swift
//  UProtect
//
//  Created by Matteo Cotena on 03/05/24.
//

import SwiftUI

let backgroundColor = Color.init(white: 0.92)

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                    ContactPickerView()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            .overlay(
                TabBarView()
                    .frame(width: geometry.size.width, height: 70)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 5)
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case course, map, danger, contact, settings
    
    internal var id: Int { rawValue }
    
    var icon: String {
        switch self {
        case .course:
            return "books.vertical.fill"
        case .map:
            return "map.fill"
        case .danger:
            return "exclamationmark.triangle.fill"
        case .contact:
            return "person.circle.fill"
        case .settings:
            return "gear"
        }
    }
    
    var title: String {
        switch self {
        case .course:
            return "Course"
        case .map:
            return "Map"
        case .danger:
            return "Danger"
        case .contact:
            return "Contact"
        case .settings:
            return "Settings"
        }
    }
    
    var color: Color {
        switch self {
        case .course:
            return .indigo
        case .map:
            return .pink
        case .danger:
            return .orange
        case .contact:
            return .teal
        case .settings:
            return .blue
        }
    }
}
