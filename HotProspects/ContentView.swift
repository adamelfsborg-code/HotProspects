//
//  ContentView.swift
//  HotProspects
//
//  Created by Adam Elfsborg on 2024-08-19.
//

import SamplePackage
import SwiftUI

struct ContentView: View {
    let posibleNumbers = Array(1...60)
    
    var results: String {
        let selected = posibleNumbers.random(7).sorted()
        let strings = selected.map(String.init)
        return strings.formatted()
    }
    
    var body: some View {
        Text(results)
    }
    

}

#Preview {
    ContentView()
}
