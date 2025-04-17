//
//  CardView.swift
//  Flashzilla
//
//  Created by Patryk Ostrowski on 09/04/2025.
//



import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    @State private var offset = CGSize.zero
    @State private var isShowingAnswer = false
    
    let card: Card
    var removal: ((Bool) -> Void)? = nil
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width / 50)))
                )
                .cardBackground(offset: offset, differentiateWithoutColor: accessibilityDifferentiateWithoutColor)
                .shadow(radius: 10)
            
            VStack {
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        //efekt obrotu w okolo wlasnej osi
        .rotationEffect(.degrees(offset.width / 0.5))
        .offset(x: offset.width * 5)
        //im dalej dragowana tym bardziej fade outuje
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        if offset.width > 0 {
                            removal?(false)
                        } else {
                            removal?(true)
                            offset = .zero
                        }
                    } else {
                        //jak sie rozmyslisz z przesuwaniem to wroci do pozycji 0
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.bouncy, value: offset)
    }
}

#Preview {
    CardView(card: .example)
}



//tutaj extension na .background, fajny przyklad.
extension View {
    //tutaj jakie wartosci musimy dostarczyc
    func cardBackground(offset: CGSize, differentiateWithoutColor: Bool) -> some View {
        self.background(
            //jezli to accesability wlaczone to daj nil, czyli bez kolorkow
            differentiateWithoutColor
            ? nil
            //jesli accesibility wylaczone to daj prostokac wypelniony kolorkami z okreslonymi warunkami
            : RoundedRectangle(cornerRadius: 25)
                .fill(
                    //jesli offset width == 0 to .white jesli nie jest == 0 to: jesli offset width wiekszy od 0 to daj kolor zielony, w innym wypadku daj czerwony, lecz jesli bedzie to 0 to dalej daj bialy bo jest to nadpisane.
                    offset.width == 0
                    ? .white
                    : (offset.width > 0 ? .green : .red)
                )
        )
    }
}

// tutaj prymitywny sposob
//let backgroundColor: Color
//
//if offset.width == 0 {
//    backgroundColor = .white
//} else if offset.width > 0 {
//    backgroundColor = .green
//} else {
//    backgroundColor = .red
//}

//    .background(
//        accessibilityDifferentiateWithoutColor
//        ? nil
//        : RoundedRectangle(cornerRadius: 25)
//            .fill(backgroundColor)
//    )

