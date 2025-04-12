//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Patryk Ostrowski on 18/02/2025.
//

import SwiftData
import SwiftUI

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
