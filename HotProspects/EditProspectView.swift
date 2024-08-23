//
//  EditProspectView.swift
//  HotProspects
//
//  Created by Adam Elfsborg on 2024-08-23.
//
import SwiftData
import SwiftUI

struct EditProspectView: View {
    @Bindable var prospect: Prospect
    var body: some View {
        Form {
            TextField("name", text: $prospect.name)
            TextField("email", text: $prospect.email)
        }
        .navigationTitle("Edit Prospect")
    }
}

#Preview {
    do {
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Prospect.self, configurations: config)
        
        let prospect = Prospect(name: "Adam Elfsborg", email: "adam@yoursite.com", isContacted: false, timestamp: .now)
        
        container.mainContext.insert(prospect)
        
        return EditProspectView(prospect: prospect)
            .modelContainer(container)
    } catch {
        return Text("Failed to preview: \(error.localizedDescription)")
    }
}
