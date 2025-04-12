//
//  ExpenseBusinessItemView.swift
//  IExpense
//
//  Created by Patryk Ostrowski on 26/02/2025.
//

import SwiftData
import SwiftUI

struct ExpenseBusinessItemView: View {
    @Environment(\.modelContext) var modelContext
    @Query var businessExpenses: [Expense]


    
    var body: some View {
        Section("Business Expenses") {
            ForEach(businessExpenses) { item in
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
            .onDelete(perform: deleteBusinessExpenses)
        }
    }
    
    init(sortOrder: [SortDescriptor<Expense>]) {
        _businessExpenses = Query(filter: #Predicate<Expense> { expense in
            expense.type == "Business"
        }, sort: sortOrder)
    }
    
    func deleteBusinessExpenses(at offsets: IndexSet) {
        for offset in offsets {
            let expense = businessExpenses[offset]
            modelContext.delete(expense)
        }
    }
}

#Preview {
    ExpenseBusinessItemView(sortOrder: [SortDescriptor(\Expense.name )])
        .modelContainer(for: Expense.self)
}
