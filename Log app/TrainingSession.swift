//
//  TrainingSession.swift
//  Log app
//
//  Created by Amtaj Dhanoa on 2026-06-23.


import Foundation
import SwiftData

@Model
class TrainingSession: Identifiable{
    var id: UUID = UUID()
    var date: Date
    var duration: Int
    var discipline: Discipline
    var notes: String

    
    @Relationship(deleteRule: .cascade)
    var sparringRounds: [Sparring] = []
    
    
    
    init(date:Date, duration:Int, discipline: Discipline, notes: String) {
        self.date = date
        self.duration = duration
        self.discipline = discipline
        self.notes = notes

    
        
        
    }
    
}
