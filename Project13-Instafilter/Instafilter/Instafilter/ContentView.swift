//
//  ContentView.swift
//  Instafilter
//
//  Created by Patryk Ostrowski on 02/03/2025.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI


struct ContentView: View {
    @Environment(\.requestReview) var requestReview
    
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingFilters = false
    
    @AppStorage("filterCount") var filterCount = 0
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                //robimy z calosc tego przycisk
                PhotosPicker(selection: $selectedItem) {
                    // Jeśli mamy już przetworzone zdjęcie, wyświetlamy je if letem bo optional
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        //jesli nie ma zdj wyswietlamy komunikat
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import photo"))
                    }
                }
                //mozemy zmienic kolor "przycisku"
//                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)
                
                Spacer()
                
                if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                    HStack {
                        Text("Intensity")
                        Slider(value: $filterIntensity)
                        // Po każdej zmianie wartości suwaka przetwarzamy obraz na nowo
                            .onChange(of: filterIntensity, applyProcessing)
                            .disabled(NoImageInputed())
                    }
                }
                if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                    HStack {
                        Text("Radius")
                        Slider(value: $filterRadius)
                        // Po każdej zmianie wartości suwaka przetwarzamy obraz na nowo
                            .onChange(of: filterRadius, applyProcessing)
                            .disabled(NoImageInputed())
                    }
                }
                
                if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                    HStack {
                        Text("Scale")
                        Slider(value: $filterScale)
                        // Po każdej zmianie wartości suwaka przetwarzamy obraz na nowo
                            .onChange(of: filterScale, applyProcessing)
                            .disabled(NoImageInputed())
                    }
                }
                
                HStack {
                    Button("Change filter", action: changeFilter )
                        .disabled(NoImageInputed())
                    
                    Spacer()
                    
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilterimage", image: processedImage))
                    }
                }
            }
            .padding([.horizontal, .bottom ])
            .navigationTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                //tak jak robi sie confirmationDialog, lecz korzystam z funkcji do ustawienia filtra
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("test") { setFilter(CIFilter.comicEffect()) }
                Button("test2") { setFilter(CIFilter.spotColor()) }
                Button("thermal") { setFilter(CIFilter.thermal()) }
                Button("wykrywcza ludzi") { setFilter(CIFilter.personSegmentation()) }
                Button("matrix") { setFilter(CIFilter.colorMatrix()) }
                
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func changeFilter() {
        showingFilters = true
        
    }
    
    //(Data → UIImage → CIImage → Image)
    func loadImage() {
        Task {
            // Pobieramy dane wybranego zdjęcia
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            // Konwertujemy dane na UIImage
            guard let inputImage = UIImage(data: imageData) else { return }
            // Tworzymy obiekt CIImage na potrzeby filtrów Core Image
            let beginImage = CIImage(image: inputImage)
            
            // Ustawiamy zdjęcie jako wejściowe do aktualnie wybranego filtra
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            // Przetwarzamy obraz po zastosowaniu filtra
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        // Pobieramy listę obsługiwanych kluczy dla aktualnie wybranego filtra
        let inputKeys = currentFilter.inputKeys
        
        // Sprawdzamy, które właściwości możemy zmieniać i ustawiamy je dynamicznie
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale * 40, forKey: kCIInputScaleKey)
        }

        
        // Generujemy obraz wyjściowy z nałożonym filtrem
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        // Konwertujemy CGImage na UIImage, a następnie na Image dla SwiftUI
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    //zamienia wybrany filter na nowo wybrany
    @MainActor func setFilter(_ filter: CIFilter) {
        //ustawaimy nowy filtr
        currentFilter = filter
        //ponownie ladujemy zdjecie by natychmiast zastosowac filtr
        loadImage()
        
        //zliczamy liczbe zmian filtra i prosimy o ocene.
        filterCount += 1
        if filterCount >= 30 {
            requestReview()
        }
    }
    
    func NoImageInputed() -> Bool {
        if selectedItem == nil {
            return true
        } else {
            return false
        }
    }
    
    func checkFilter() {
        
    }
}


#Preview {
    ContentView()
}
