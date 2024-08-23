//
//  ProspectsListingView.swift
//  HotProspects
//
//  Created by Adam Elfsborg on 2024-08-23.
//
import CodeScanner
import SwiftData
import SwiftUI

struct ProspectsListingView: View {
    @Environment(\.modelContext) var modelContext
    @Query var prospects: [Prospect]
    
    @Binding var selection: Set<Prospect>
    
    let filter: FilterType
    
    let contactedIcon = "person.crop.circle.fill.badge.checkmark"
    let uncontactedIcon = "person.crop.circle.badge.xmark"

    var body: some View {
        List(selection: $selection) {
            ForEach(filteredProspects, id: \.self) { prospect in
                NavigationLink {
                    EditProspectView(prospect: prospect)
                } label: {
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
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .contacted:
            return prospects.filter { $0.isContacted }
        case .uncontacted:
            return prospects.filter { !$0.isContacted }
        case .none:
            return prospects
        }
    }
    
    init(filter: FilterType, sort: [SortDescriptor<Prospect>], selection: Binding<Set<Prospect>>) {
        self._selection = selection
        self.filter = filter
        
        if filter != .none {
            let showContactedOnly = filter == .contacted
            _prospects = Query(filter: #Predicate {
                $0.isContacted == showContactedOnly
            }, sort: sort)
        } else {
            _prospects = Query(sort: sort)
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.email
            content.sound = UNNotificationSound.default
            
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
    ProspectsListingView(filter: .none, sort: [SortDescriptor(\Prospect.name)], selection: .constant(Set()))
}
