//
//  ContentView.swift
//  Flashzilla
//
//  Created by Patryk Ostrowski on 31/03/2025.
//

import SwiftUI

extension View {
    //po prostu jest to modyfikator do zeby byl fajny efekt potem przesuwania kart, a ta funkcja odpowiada za ich pozycje Y na ekranie
    //modyfikator, który przyjmuje pozycję w tablicy wraz z całkowitym rozmiarem tablicy i przesuwa widok o pewną wartość na podstawie tych wartości.
    //uloz na stosie na pozycji z calkowitym roznimarem tablkicy oddaj jakies view
    func stacked(at position: Int, in total: Int) -> some View {
        //offset to wartosc gdzie od wszystkich rzeczy w arrayu odejmujemy pozycje co daje nam offset ktory ustawia widok
        let offset = Double(total - position)
        //mznozymy razy 10 zeby byl na srodku
        return self.offset(y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    //daj mi 10 kart przykladowych
    @State private var cards = DataManager.load()
    @State private var showingEditScreen = false
    
    @State private var timeRemaining = 100
    //timer wykonuje cos co 1 sekunde
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true

    var body: some View {
        //wszystko dac nad background image.
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            
            
            VStack {//time obove cards
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                
                ZStack {//cards
                    // dla kazdego indexu w card view wyswietl karte o indexie jakims tam, mozna nakladac modyfikatory
                    ForEach(Array(cards.enumerated()), id: \.element) { item in
                        CardView(card: item.element) { reinsert in
                            //when its triggerd
                            withAnimation {
                                removeCard(at: item.offset, reinsert: reinsert)
                            }
                        }
                        .stacked(at: item.offset, in: cards.count)
                        //jezeli index jest rowny karcie na samej gorze daje true, czyli umozliwia interakcje.
                        .allowsHitTesting(item.offset == cards.count - 1)
                        .accessibilityHidden(item.offset < cards.count - 1)
                    }
                }
                //wylacza interaktywnosc widoku gdy jest false, w tym wypadku gdy pozostaly czas spadnie do 0 to blokuje mozliwosc przesuwania kart
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditScreen = true
                        print("Differentiate: \(accessibilityDifferentiateWithoutColor), VoiceOver: \(accessibilityVoiceOverEnabled)")

                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }
                
                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1, reinsert: true)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1, reinsert: false)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your anser as being correct")
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        //onRecive performuje akcje kiedy wykryje dane wyemitowane przez danego publishera,
        .onReceive(timer) { time in
            //jesli aplikacja jest aktywna to
            guard isActive else { return }
            
            // jesli pozostaly czas jest wiekszy od zera to odejmuj 1
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        //Sprawdza czy mamy otwarta aplikacje
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                //jesli karty dalej sa to isActive true
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        //jesli init nie ma parametor ktore trzeba ustawic przed wywolaniem, to moge View do ktorego sie przenosze umiewsic w .sheet, a nie w closer dla .sheet, lecz musze dodac .init
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }
    
    func removeCard(at index: Int, reinsert: Bool) {
        guard index >= 0 else { return }
        
        if reinsert {
            cards.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
        } else {
            cards.remove(at: index)
        }
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        cards = DataManager.load()
    }
    
}

#Preview {
    ContentView()
}



