//
//  UProtectApp.swift
//  UProtect
//
//  Created by Matteo Cotena on 03/05/24.
//

import SwiftUI
@main
struct UProtectApp: App {
    // Forzato la light mode nell'app
    @AppStorage("theme") var theme: String = "light"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(theme == "" ? .none : theme == "dark" ? .dark : .light)

        }
    }
}
