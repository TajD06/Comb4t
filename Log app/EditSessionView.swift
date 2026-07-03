//
//  EditSessionView.swift
//  Log app
//
//  Created by Amtaj Dhanoa on 2026-07-03.
//
import SwiftUI
import SwiftData

struct EditSessionView: View  {
    
    var session: TrainingSession
    @State private var date: Date = .now
    @State private var durationMins: Int = 0
    @State private var discipline: Discipline = .striking
    @State private var notes: String = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    var body : some View {
        Form {
            Section {
                DatePicker("Date", selection: $date)
            }
            
            Section {
                Picker("Discipline", selection: $discipline) {
                    Text("Striking").tag(Discipline.striking)
                    Text("Grappling").tag(Discipline.grappling)
                    Text("MMA").tag(Discipline.MMA)
                }
                
                Picker("Duration", selection: $durationMins) {
                    ForEach(Array(stride(from: 0, to: 305, by: 1)), id: \.self) { mins in
                        Text("\(mins) mins").tag(mins)
                    }
                }
                .pickerStyle(.wheel)
                
                TextField("Notes", text: $notes, axis: .vertical)
                
                Button("Save") {
                    session.date = date
                    session.discipline = discipline
                    session.duration = durationMins
                    session.notes = notes
                    dismiss()
                    
                }
                
            }
            Section("Sparring Rounds") {
                if session.sparringRounds.isEmpty {
                    Text("No sparring logged")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(session.sparringRounds) { round in
                        VStack(alignment: .leading) {
                            Text("Rounds: \(round.rounds)")
                            Text("\(round.minutesPerRound) min per round")
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let round = session.sparringRounds[index]
                            context.delete(round)
                        }
                    }
                }
            }
            
        }
        .onAppear {
            date = session.date
            durationMins = session.duration
            discipline = session.discipline
            notes = session.notes
        }
        
    }
}
