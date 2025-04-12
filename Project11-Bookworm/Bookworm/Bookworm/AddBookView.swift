//
//  AddBookView.swift
//  Bookworm
//
//  Created by Patryk Ostrowski on 20/02/2025.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    private enum Field: Int, CaseIterable {
        case title, author, review
    }
    
    @FocusState private var focusedField: Field?

    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = "Default"
    @State private var review = ""
    @State private var forVibration = 0
    
    var disableForm: Bool {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedReview = review.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return trimmedTitle.isEmpty || trimmedAuthor.isEmpty || trimmedReview.isEmpty
    }
    

    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller", "Default"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                        .focused($focusedField, equals: .title)
                    TextField("Author's name", text: $author)
                        .focused($focusedField, equals: .author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
  
                }
                
                Section("Write a review") {
                    TextEditor(text: $review)
                        .focused($focusedField, equals: .review)
                    ratingView(rating: $rating)
                }
                
                Section {
                    Button("Save") {
                        forVibration += 1
                        let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating, date: Date.now)
                        modelContext.insert(newBook)
                        dismiss()
                    }
                    //jesli true to wylacz przycisk, wiec chcemy zeby disable form oddawalo true, jak co kolwiek jest puste
                    .disabled(disableForm)
                    .sensoryFeedback(.impact(weight: .light), trigger: title)
                    .sensoryFeedback(.impact(weight: .light), trigger: author)
                    .sensoryFeedback(.impact(weight: .light), trigger: review)
                    .sensoryFeedback(.impact(weight: .heavy), trigger: forVibration)
                }
            }
            .navigationTitle("Add Book")
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
    }
}

#Preview {
    AddBookView()
}
