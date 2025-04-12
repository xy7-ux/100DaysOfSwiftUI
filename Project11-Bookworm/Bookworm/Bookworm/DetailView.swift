//
//  DetailView.swift
//  Bookworm
//
//  Created by Patryk Ostrowski on 21/02/2025.
//

import SwiftData
import SwiftUI

struct DetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    let book: Book
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottom) {
                Image(book.genre)
                    .resizable()
                    .scaledToFit()
                
                HStack {
                    Text("added at: \(book.date, format: .dateTime)")
                        .fontWeight(.medium)
                        .padding(8)
                        .foregroundStyle(.white)
                        .background(.black.opacity(0.75))
                        .clipShape(.capsule)
                        .offset(x: 5, y: -5)
                    
                    Spacer()
                    
                    Text(book.genre.uppercased())
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundStyle(.white)
                        .background(.black.opacity(0.75))
                        .clipShape(.capsule)
                        .offset(x: -5, y: -5)
                }
            }
            
            Text(book.author)
                .font(.title)
                .foregroundStyle(.secondary)
            
            //Tutaj date dodania Text(Date.now, format: .dateTime.day().month().year()
            Text(book.date, format: .dateTime.second().minute().hour().day().month().year())
            
            Text(book.review)
                .padding()
            
            ratingView(rating: .constant(book.rating))
                .font(.largeTitle)
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Delete book", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button("Delete this book", systemImage: "trash") {
                showingDeleteAlert = true
            }
        }
    }
    
    func deleteBook() {
        modelContext.delete(book)
        dismiss()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Book(title: "Test book", author: "Test author", genre: "Fantasy", review: "This was a great book i really enjoy itt !!!!!", rating: 4)
        
        return DetailView(book: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create a previev: \(error.localizedDescription)")
    }
}
