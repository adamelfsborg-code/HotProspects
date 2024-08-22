//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Adam Elfsborg on 2024-08-22.
//
import SwiftData
import SwiftUI
import CodeScanner

struct ProspectsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    @State private var isShowingScanner = false
    @State private var selection = Set<Prospect>()
    
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
            List(prospects, selection: $selection) { prospect in
                VStack(alignment: .leading) {
                    Text(prospect.name)
                        .font(.headline)
                    Text(prospect.email)
                        .foregroundStyle(.secondary)
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    } else {
                        
                        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                    }
                }
                .tag(prospect)
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                if selection.isEmpty == false {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete Selected",role: .destructive, action: delete)
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Adam Elfsborg\nadam.elfsborg@hotmail.com", completion: handleScan)
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
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let success):
            let details = success.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            let person = Prospect(name: details[0], email: details[1], isContacted: false)
            modelContext.insert(person)
        case .failure(let failure):
            print("Scanning failed: \(failure.localizedDescription)")
        }
        
    }
    
    func delete() {
        for prospect in selection {
            modelContext.delete(prospect)
        }
    }
        
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
    
}
