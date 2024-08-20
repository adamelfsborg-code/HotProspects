//
//  ContentView.swift
//  HotProspects
//
//  Created by Adam Elfsborg on 2024-08-19.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = "One"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Button("Show tab two") {
                selectedTab = "Two"
            }
            .tag("One")
            .tabItem {
                Label("One", systemImage: "rectangle")
            }
            Button("Show tab one") {
                selectedTab = "One"
            }
            .tag("Two")
            .tabItem {
                Label("Two", systemImage: "circle")
            }
        }
    }
}

#Preview {
    ContentView()
}
