//
//  ContentView.swift
//  HotProspects
//
//  Created by Adam Elfsborg on 2024-08-19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            Text("Steve Jobs")
                .swipeActions {
                    Button("Delte", systemImage: "minus.circle", role: .destructive) {
                        print("Delete")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button("Message", systemImage: "message") {
                        print("Hi")
                    }
                    Button("Pin", systemImage: "pin") {
                        print("Pinned")
                    }
                    .tint(.orange)
                }
        }
    }
    

}

#Preview {
    ContentView()
}
