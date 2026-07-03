//
//  rounds.swift
//  Log app
//
//  Created by Amtaj Dhanoa on 2026-06-23.
//
import Foundation
import SwiftData

@Model
class Sparring: Identifiable {
    var id: UUID = UUID()
    var rounds: Int
    var minutesPerRound: Int
    var discipline: Discipline
    
 
    var session: TrainingSession?
    
    init(rounds: Int, minutesPerRound: Int, discipline: Discipline) {
        self.rounds = rounds
        self.minutesPerRound = minutesPerRound
        self.discipline = discipline
    }
}
