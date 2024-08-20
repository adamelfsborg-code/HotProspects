//
//  ContentView.swift
//  HotProspects
//
//  Created by Adam Elfsborg on 2024-08-19.
//

import SwiftUI

struct ContentView: View {
    @State private var backgroundColor = Color.red
    var body: some View {
        VStack {
            
            Rectangle()
                .fill(backgroundColor)
                .cornerRadius(20)
                .frame(height: 300)
                .padding()
                .cornerRadius(20)
            
           
            Text("Change Background")
                .padding()
                .contextMenu {
                    Button("Red",systemImage: backgroundColor == .red ? "checkmark.circle.fill" : "checkmark.circle", role: .destructive) {
                        withAnimation {
                            backgroundColor = .red
                        }
                    }
                    Button("Blue", systemImage: backgroundColor == .blue ? "checkmark.circle.fill" : "checkmark.circle") {
                        withAnimation {
                            backgroundColor = .blue
                        }
                    }
                    Button("Yellow", systemImage: backgroundColor == .yellow ? "checkmark.circle.fill" : "checkmark.circle") {
                        withAnimation {
                            backgroundColor = .yellow
                        }
                    }
                    Button("Green", systemImage: backgroundColor == .green ? "checkmark.circle.fill" : "checkmark.circle") {
                        withAnimation {
                            backgroundColor = .green
                        }
                    }
                    Button("Cancel", systemImage: "checkmark.circle") {}
                }
        }
    }
    

}

#Preview {
    ContentView()
}
