//
//  Technique.swift
//  Log app
//
//  Created by Amtaj Dhanoa on 2026-06-23.
//

import SwiftData
import Foundation


@Model
class Technique {
    var name: String
    var category: String
    var notes: String
    
    init(name: String, category: String, notes: String) {
        self.name = name
        self.category = category
        self.notes = notes
    }
    
    
}
