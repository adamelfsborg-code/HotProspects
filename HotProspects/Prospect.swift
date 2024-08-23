//
//  Prospect.swift
//  HotProspects
//
//  Created by Adam Elfsborg on 2024-08-22.
//

import Foundation
import SwiftData

@Model
class Prospect {
    var name: String
    var email: String
    var isContacted: Bool
    var timestamp: Date
    
    init(name: String, email: String, isContacted: Bool, timestamp: Date) {
        self.name = name
        self.email = email
        self.isContacted = isContacted
        self.timestamp = timestamp
    }
}
