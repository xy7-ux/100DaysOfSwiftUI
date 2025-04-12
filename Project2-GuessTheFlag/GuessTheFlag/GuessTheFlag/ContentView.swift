//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Patryk Ostrowski on 20/12/2024.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    var isSelected: Bool
    var isFaded: Bool
    
    var body: some View {
        Image(country)
            .resizable()
            .scaledToFit()
            .clipShape(Capsule())
            .shadow(radius: 5)
            .frame(width: 150, height: 100)
            .opacity(isFaded ? 0.5 : 1)
            .blur(radius: isFaded ? 7 : 0)
            .scaleEffect(isFaded ? 0.5 : 1)
            

    }
}

struct LargeBlueFont: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle.weight(.bold))
            .foregroundStyle(.white)
    }
}


struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    @State private var userScore = 0
    @State private var questionCount = 0
    private let totalQuestion = 8
    
    @State private var selectedFlag: Int? = nil
    

    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.4, green: 0.2, blue: 0.95), location: 0.3),
                .init(color: Color(red: 0.10, green: 0.50, blue: 0.46), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                LargeBlueFont(text: "Guess the flag")
                    
                
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            selectedFlag = number

                        } label: {
                            FlagImage(
                                country: countries[number],
                                isSelected: selectedFlag == number,
                                isFaded: selectedFlag != nil && selectedFlag != number
                            )
                        }
                        .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z:0))
                        .animation(.easeInOut(duration: 0.8), value: selectedFlag)
                        .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                


                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore)")
        }
        
        .alert("Game Over", isPresented: $showingFinalScore) {
            Button("Restart", action: resetGame)
        } message: {
            Text("Your final score is \(userScore) out of \(totalQuestion)")
        }
        
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong that's flag of \(countries[number]) "
        }
        
        questionCount += 1
        
        if questionCount == totalQuestion {
            showingFinalScore = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = nil
    }
    
    func resetGame() {
        userScore = 0
        questionCount = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
}

#Preview {
    ContentView()
}
