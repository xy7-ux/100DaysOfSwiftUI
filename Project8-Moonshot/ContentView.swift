//
//  ContentView.swift
//  Moonshot
//
//  Created by Patryk Ostrowski on 03/02/2025.
//

import SwiftUI



struct ContentView: View {
    @State private var showingGrid = true
    
    
    
    var body: some View {
        NavigationStack {
            Group {
                if showingGrid {
                    GridLayout()
                } else {
                    ListLayout()
                }
            }
            .toolbar {
                Button("change grid to list" ,systemImage: showingGrid ? "list.bullet" : "square.grid.2x2") {
                    withAnimation {
                        showingGrid.toggle()
                    }
                }
            }
            .navigationTitle("Moonshot")
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
}
