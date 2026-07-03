//
//  SparringFormView.swift
//  Log app
//
//  Created by Amtaj Dhanoa on 2026-06-24.
//

import SwiftData
import SwiftUI

struct SparringFormView: View {
    @State private var rounds: Int = 0
    @State private var mins: Int = 0
    @State private var discipline: Discipline = .grappling
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
  
    var onSave: (Sparring) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Stepper("Rounds: \(rounds)", value: $rounds, in: 0...20, step: 1)
                    Stepper("Minutes per Round: \(mins)", value: $mins, in: 0...10, step: 1)
                    
                    Picker("Discipline:", selection: $discipline) {
                        Text("Striking").tag(Discipline.striking)
                        Text("Grappling").tag(Discipline.grappling)
                        Text("MMA").tag(Discipline.MMA)
                    }
                    
                }

            }
            .navigationTitle("Sparring")
                       .toolbar {
                           ToolbarItem(placement: .topBarLeading) {
                               Button("Cancel") {
                                   dismiss()
                               }
                           }
                           ToolbarItem(placement: .topBarTrailing) {
                               Button("Save") {
                                   let sparring = Sparring(
                                       rounds: rounds,
                                       minutesPerRound: mins,
                                       discipline: discipline
                                   )
                                   onSave(sparring)
                                   dismiss()
                               }
                           }
                       }
                   }
               }
           }

