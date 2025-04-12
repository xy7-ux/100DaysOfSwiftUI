//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Patryk Ostrowski on 16/02/2025.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            
            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
            }
            // jesli disabled == false to przycisk nie jest zablokowany, wiec chcemy zeby hasvalidAdres zwracalo false jesli address jest poprawny, a zeby zwracalo true jesli adres jest zly
            .disabled(!order.hasValidAddress)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear(perform: {
            //save to user defults
            if let data = try? JSONEncoder().encode(order) {
                UserDefaults.standard.set(data, forKey: "orderKey")
            }
        })
        .onAppear(perform: {
            if let object = UserDefaults.standard.value(forKey: "orderKey") as? Data {
                if let loadedOrder = try? JSONDecoder().decode(Order.self, from: object) {
                    self.order.name = loadedOrder.name
                    self.order.streetAddress = loadedOrder.streetAddress
                    self.order.city = loadedOrder.city
                    self.order.zip = loadedOrder.zip
                    print("obiekt zaladowany")
                }
            }
        })
    }
}

#Preview {
    AddressView(order: Order())
}
