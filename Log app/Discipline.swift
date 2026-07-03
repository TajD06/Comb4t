//
//  Discipline.swift
//  Log app
//
//  Created by Amtaj Dhanoa on 2026-06-23.
//

import Foundation
import SwiftData

enum Discipline: String, Codable {
    case striking, grappling, MMA
    
    
    
    var DisplayName: String{
        switch self {
        case .striking:
            return "Striking"
        case .grappling:
            return "Grappling"
        case .MMA:
            return "MMA"
            
        }
        
    }
    
}
