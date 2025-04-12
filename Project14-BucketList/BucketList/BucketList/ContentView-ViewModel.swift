//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Patryk Ostrowski on 11/03/2025.
//

import CoreLocation
import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
    @Observable
    class ViewModel {
        //moze byc tak anie locations = [Location]() bo w init robimy pusty zbior
        private(set) var locations: [Location]
        var selectedPlace: Location?
        var isUnlocked = false
        var isHybrid = false
        var isAlertPresented = false
        var unlockErrorMessage = ""
        
        let savePath = URL.documentsDirectory.appending(path: "Saved Places ")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        // zamieniamy obiekt locations na JSON date i write na doumentsdirectory robimy
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data")
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        print("Authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                        self.unlockErrorMessage = "Authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")"
                        self.isAlertPresented = true
                    }
                }
            } else {
                print("No biometrics")
            }
        }
    }
}
