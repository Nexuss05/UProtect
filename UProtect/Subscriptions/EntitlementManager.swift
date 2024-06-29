//
//  EntitlementManager.swift
//  UProtect
//
//  Created by Andrea Romano on 29/06/24.
//


import SwiftUI

class EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.com.andrearomano.Hestia")!
    
    @AppStorage("hasPro", store: userDefaults)
    var hasPro: Bool = false
}

