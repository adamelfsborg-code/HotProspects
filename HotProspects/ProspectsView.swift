//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Adam Elfsborg on 2024-08-22.
//
import CodeScanner
import SwiftData
import SwiftUI
import UserNotifications

enum FilterType {
    case none, contacted, uncontacted
}

struct ProspectsView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var isShowingScanner = false
    @State private var sort = [
        SortDescriptor(\Prospect.name, order: .forward), 
        SortDescriptor(\Prospect.timestamp, order: .reverse)
    ]
    @State private var selection = Set<Prospect>()

    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var body: some View {
        NavigationStack {
            ProspectsListingView(filter: filter, sort: sort, selection: $selection)
                .navigationTitle(title)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button(action: { isShowingScanner = true }) {
                            Label("Scan", systemImage: "qrcode.viewfinder")
                        }
                        
                        Menu {
                            Picker("Sort", selection: $sort) {
                                Text("Name").tag([
                                    SortDescriptor(\Prospect.name, order: .forward),
                                    SortDescriptor(\Prospect.timestamp, order: .reverse)
                                ])
                                Text("Recent").tag([
                                    SortDescriptor(\Prospect.timestamp, order: .reverse),
                                    SortDescriptor(\Prospect.name, order: .forward)
                                ])
                            }
                            .pickerStyle(.inline)
                        } label: {
                            Label("Sort", systemImage: "arrow.up.arrow.down")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                    
                    if !selection.isEmpty {
                        ToolbarItem(placement: .bottomBar) {
                            Button("Delete Selected", role: .destructive, action: delete)
                        }
                    }
                }
                .sheet(isPresented: $isShowingScanner) {
                    let names = ["Steve Jobs": "steve.jobs@apple.com", "Steve Wozniak": "steve.wozniak@apple.com", "Tim Cook": "tim.cook@apple.com", "Craig Federighi": "craig.federighi@apple.com", "Carol Surface": "carol.surface@apple.com"]
                    
                    let name = names.randomElement()!
                    let string = "\(name.key)\n\(name.value)"
                    
                    CodeScannerView(codeTypes: [.qr], simulatedData: string, completion: handleScan)
                }
        }
    }
    
    func delete() {
        for prospect in selection {
            modelContext.delete(prospect)
        }
        selection.removeAll()
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let success):
            let details = success.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            let person = Prospect(name: details[0], email: details[1], isContacted: false, timestamp: .now)
            modelContext.insert(person)
        case .failure(let failure):
            print("Scanning failed: \(failure.localizedDescription)")
        }
    }
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}
