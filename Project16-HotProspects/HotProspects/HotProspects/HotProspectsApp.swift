//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Patryk Ostrowski on 19/03/2025.
//

import SwiftUI

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
