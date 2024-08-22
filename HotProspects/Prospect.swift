//
//  Prospect.swift
//  HotProspects
//
//  Created by Adam Elfsborg on 2024-08-22.
//

import SwiftData

@Model
class Prospect {
    var name: String
    var email: String
    var isContacted: Bool
    
    init(name: String, email: String, isContacted: Bool) {
        self.name = name
        self.email = email
        self.isContacted = isContacted
    }
}
