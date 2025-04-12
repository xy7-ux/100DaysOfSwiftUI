//
//  EditProspectView.swift
//  HotProspects
//
//  Created by Patryk Ostrowski on 27/03/2025.
//

import SwiftUI

struct EditProspectView: View {
    @Bindable var prospect: Prospect
    
    var body: some View {
        Form {
            Section("Edit name") {
                TextField("name", text: $prospect.name)
            }
            Section("Edit email Address") {
                TextField("emailAddress", text: $prospect.emailAddress)
            }
            Toggle("Contacted", isOn: $prospect.isContacted)
        }
        .navigationTitle("Edit")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EditProspectView(prospect: Prospect(name: "Tomasz Kowalski", emailAddress: "kowalson@gmail.com", isContacted: true))
}

