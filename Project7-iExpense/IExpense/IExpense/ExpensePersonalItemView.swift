//
//  ExpensePersonalItemView.swift
//  IExpense
//
//  Created by Patryk Ostrowski on 26/02/2025.
//

import SwiftData
import SwiftUI

struct ExpensePersonalItemView: View {
    @Environment(\.modelContext) var modelContext
    @Query var personalExpenses: [Expense]


    
    var body: some View {
        Section("Personal Expenses") {
            ForEach(personalExpenses) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.type)
                            .font(.subheadline)
                        
                    }
                    
                    Spacer()
                    
                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundStyle(item.amount >= 100 ? .red : (item.amount >= 50 ? .green : .yellow))
                }
                .accessibilityElement()
                .accessibilityLabel("\(item.name), value: \(item.amount)")
                .accessibilityHint("type: \(item.type)")
            }
            .onDelete(perform: deleteExpenses)
        }
    }
    
    init(sortOrder: [SortDescriptor<Expense>]) {
        _personalExpenses = Query(filter: #Predicate<Expense> { expense in
            expense.type == "Personal"
        }, sort: sortOrder)
    }
    
    func deleteExpenses(at offsets: IndexSet) {
        for offset in offsets {
            let expense = personalExpenses[offset]
            modelContext.delete(expense)
        }
    }
}

#Preview {
    ExpensePersonalItemView(sortOrder: [SortDescriptor(\Expense.name )])
        .modelContainer(for: Expense.self)
}
