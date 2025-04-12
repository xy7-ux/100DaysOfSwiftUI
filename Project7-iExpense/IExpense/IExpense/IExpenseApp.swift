//
//  IExpenseApp.swift
//  IExpense
//
//  Created by Patryk Ostrowski on 29/01/2025.
//

import SwiftUI

@main
struct IExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Expense.self)
    }
}
