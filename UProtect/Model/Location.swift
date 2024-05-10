//
//  Location.swift
//  UProtect
//
//  Created by Matteo Cotena on 10/05/24.
//

import Foundation

struct Location: Identifiable {
    let id = UUID()
    let title: String
    let address: String
    let latitude: Double
    let longitude: Double
    let hours: String
}
