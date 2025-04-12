//
//  ContentView.swift
//  BetterRest
//
//  Created by Patryk Ostrowski on 13/01/2025.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeAmount = 1

    
    @State private var recommendedBedtime = ""

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }

    var body: some View {
        NavigationStack {
            Form {
                //Wybór godziny pobudki
                Section(header: Text("When do you want to wake up?").font(.headline)) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: wakeUp) {
                            updateBedtime()
                        }
                }

                //Ilość snu
                Section(header: Text("Desired Amount").font(.headline)) {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        .onChange(of: sleepAmount) {
                            updateBedtime()
                        }
                }

                //Ilość kawy
                Section(header: Text("Daily coffee intake").font(.headline)) {
                    Picker("Coffee cups", selection: $coffeAmount) {
                        ForEach(0..<21) { number in
                            Text("\(number) \(number == 1 ? "cup" : "cups")").tag(number)
                        }
                    }
                    .onChange(of: coffeAmount) {
                        updateBedtime()
                    }
                }

                //Wynik
                Section(header: Text("Your ideal bedtime is").font(.headline)) {
                    Text(recommendedBedtime)
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .navigationTitle("Better Rest")
            .onAppear(perform: updateBedtime) //Obliczenie wyniku przy starcie aplikacji
        }
    }

    //Funkcja obliczająca godzinę snu
    func updateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60

            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeAmount)
            )

            let sleepTime = wakeUp - prediction.actualSleep
            recommendedBedtime = sleepTime.formatted(date: .omitted, time: .shortened)

        } catch {
            recommendedBedtime = "Error"
        }
    }
}

#Preview {
    ContentView()
}
