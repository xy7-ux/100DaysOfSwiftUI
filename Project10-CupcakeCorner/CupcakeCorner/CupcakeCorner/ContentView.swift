//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Patryk Ostrowski on 14/02/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var order = Order()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    //w selection wybieramy co bedzie wyswietlane (musi byc to jeden element)
                    Picker("Select you cake type", selection: $order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                Section {
                    // Toggle to taki switch do przesuwania, mozna zmieniac z false na true . isOn musi byc chyba uzuwane zeby wiadomo do czego odnosci sie toogle, do tego mozna zrobic cos jesli wartosc zmieni sie na true.
                    Toggle("Any special request", isOn: $order.specialRequestEnabled)
                    
                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        
                        Toggle("Add sprinkles", isOn: $order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink("Delivery details") {
                        //tutaj 1 order to ten z tego view do ktorego chemy pojsc, 2 to ten z tego view, ten z ktorego chcemy wyslac dane dalej.
                        AddressView(order: order)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

#Preview {
    ContentView()
}
