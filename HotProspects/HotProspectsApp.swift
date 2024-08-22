//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Adam Elfsborg on 2024-08-19.
//

import SwiftData
import SwiftUI

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Prospect.self)
        }
    }
}
