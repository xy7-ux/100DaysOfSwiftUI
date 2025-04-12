//
//  ContentView.swift
//  BucketList
//
//  Created by Patryk Ostrowski on 06/03/2025.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
     )
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.isUnlocked {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "mappin.and.ellipse")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
//                                    .background(.white.opacity(0.0))
//                                    .clipShape(.circle)
                                    .onLongPressGesture(minimumDuration: 0.2) {
                                        viewModel.selectedPlace = location
                                        print("Long press detected")
                                    }
                                
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Change map view", systemImage: viewModel.isHybrid ? "map.fill" : "map") {
                                viewModel.isHybrid.toggle()
                            }
                        }
                    }
                    .toolbarBackground(.hidden, for: .navigationBar)
                    .mapStyle(viewModel.isHybrid ? .hybrid(elevation: .realistic) : .standard)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
                }
            } else {
                Button("Unlock places", action: viewModel.authenticate)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
                    .alert(isPresented: $viewModel.isAlertPresented) {
                        Alert(title: Text("Authentication error"), message: Text(viewModel.unlockErrorMessage), dismissButton: .default(Text("Dismiss")))
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
