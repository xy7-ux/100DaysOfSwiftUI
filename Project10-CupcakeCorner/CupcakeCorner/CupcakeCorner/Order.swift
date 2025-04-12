//
//  Order.swift
//  CupcakeCorner
//
//  Created by Patryk Ostrowski on 16/02/2025.
//

import Foundation

//Obczaj poprzedni projekt i zastanow sie ze problem z danymi mogl wynikac dlatego ze nie przypisywalem im w klasie tak jak tutaj.

@Observable
class Order: Codable {
    // Ta lista jest wspólna dla wszystkich instancji klasy Order.
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zip = "zip"
    }
    
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        // Jeśli specialRequestEnabled jest wyłączone, resetujemy dodatkowe opcje.
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }

    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    
    
    
    var hasValidAddress: Bool {

        //jesli choc jedna rzecz zwraca true, czyli np name jest puste hasValidAddress zwraca false, jesli wszystko przechodzi zwraca true
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedStreetAddress = streetAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCity = streetAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedZip = zip.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return !trimmedName.isEmpty && !trimmedStreetAddress.isEmpty && !trimmedCity.isEmpty && !trimmedZip.isEmpty
    }
    
    var cost: Decimal {
        //2$ per cake
        var cost = Decimal(quantity) * 2
        
        //complicated cakes cost more
        cost += Decimal(type) / 2
        
        // 1$/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        //0.50$/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
}
