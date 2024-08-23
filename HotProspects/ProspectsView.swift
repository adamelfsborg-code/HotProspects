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

struct ProspectsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    @State private var isShowingScanner = false
    @State private var selection = Set<Prospect>()
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    let contactedIcon = "person.crop.circle.fill.badge.checkmark"
    let uncontactedIcon = "person.crop.circle.badge.xmark"
    
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
                HStack {
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.email)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if filter == .none {
                        if prospect.isContacted {
                            Image(systemName: contactedIcon)
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: uncontactedIcon)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: uncontactedIcon) {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    } else {
                        
                        Button("Mark Contacted", systemImage: contactedIcon) {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                        
                        Button("Remind Me", systemImage: "bell") {
                            addNotification(for: prospect)
                        }
                        .tint(.orange)
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
                let names = ["Steve Jobs": "steve.jobs@apple.com", "Steve Wozniak": "steve.wozniak@apple.com", "Tim Cook": "tim.cook@apple.com", "Craig Federighi": "craig.federighi@apple.com", "Carol Surface": "carol.surface@apple.com"]
                
                let name = names.randomElement()!
                let string = "\(name.key)\n\(name.value)"
                
                CodeScannerView(codeTypes: [.qr], simulatedData: string, completion: handleScan)
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
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.email
            content.sound = UNNotificationSound.default
            
            //var dateComponents = DateComponents()
            //dateComponents.hour = 9
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
        
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
    
}
