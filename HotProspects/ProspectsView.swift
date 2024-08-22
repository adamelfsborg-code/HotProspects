//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Adam Elfsborg on 2024-08-22.
//
import SwiftData
import SwiftUI

struct ProspectsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }
    
    var body: some View {
        NavigationStack {
            List(prospects) { prospect in
                VStack(alignment: .leading) {
                    Text(prospect.name)
                        .font(.headline)
                    Text(prospect.email)
                        .foregroundStyle(.secondary)
                }
            }
                .navigationTitle(title)
                .toolbar {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        let prospect = Prospect(name: "Adam Elfsborg", email: "adam.elfsborg@hotmail.com", isContacted: false)
                        modelContext.insert(prospect)
                    }
                }
        }
    }
    
    init(filter: FilterType) {
        self.filter = filter
       
        if filter != .none {
            let showContactedOnly = filter == .contacted
            _prospects = Query(filter: #Predicate {
                $0.isContacted == showContactedOnly
            }, sort: [SortDescriptor(\Prospect.name)])
        }
        
    }
        
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
    
}
