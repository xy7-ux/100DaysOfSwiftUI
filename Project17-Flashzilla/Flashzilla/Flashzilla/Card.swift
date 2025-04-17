//
//  Card.swift
//  Flashzilla
//
//  Created by Patryk Ostrowski on 09/04/2025.
//

import Foundation

struct Card: Codable, Equatable, Hashable, Identifiable {
    var id = UUID()
    var prompt: String
    var answer: String
    
    static let example = Card(prompt: "Who played 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
