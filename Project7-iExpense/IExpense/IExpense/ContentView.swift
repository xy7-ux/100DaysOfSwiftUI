//
//  ContentView.swift
//  IExpense
//
//  Created by Patryk Ostrowski on 29/01/2025.
//




import SwiftData
import SwiftUI

enum FilterOptions {
    case allExpenses
    case businessExpenses
    case personalExpenses
}

enum SortingOrder {
    case nameAmount
    case amountName
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    
    
    @Query var expenses: [Expense]
    
    @State private var filter = FilterOptions.allExpenses
    
    @State private var sortOrder = [
        SortDescriptor(\Expense.name),
        SortDescriptor(\Expense.amount)
    ]
    
    var body: some View {
        NavigationStack {
            List {
                if filter == .allExpenses || filter == .personalExpenses {
                    ExpensePersonalItemView(sortOrder: sortOrder)
                }
                
                if filter == . allExpenses || filter == .businessExpenses {
                    ExpenseBusinessItemView(sortOrder: sortOrder)
                }
            }
            .navigationTitle("IExpense")
            .toolbar {
                NavigationLink {
                    AddView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Image(systemName: "plus")
                }
                
                
                Menu("sort", systemImage: "arrow.up.arrow.down") {
                    Picker("sort", selection: $sortOrder) {
                        Text("By name")
                            .tag([
                                SortDescriptor(\Expense.name),
                                SortDescriptor(\Expense.amount)
                            ])
                        Text("By amount")
                            .tag([
                                SortDescriptor(\Expense.amount),
                                SortDescriptor(\Expense.name)
                            ])
                    }
                }
                
                Menu("Filter", systemImage: "slider.horizontal.3") {
                    Picker("Filter", selection: $filter) {
                        Text("Show all Expenses")
                            .tag(FilterOptions.allExpenses)
                        Text("Show Business Expenses")
                            .tag(FilterOptions.businessExpenses)
                        Text("Show Personal Expenses")
                            .tag(FilterOptions.personalExpenses)
                        
                    }
                }
            }
        }
    }
    
    
    
}

#Preview {
    ContentView()
}
