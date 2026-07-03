//
//  SessionDetailView.swift
//  Log app
//
//  Created by Amtaj Dhanoa on 2026-06-29.
//

import SwiftUI
import SwiftData


struct SessionDetailView: View {
    var session: TrainingSession
    @State private var showEdit = false
    
    var body: some View {
        Form {
            Section {
                Text(session.discipline.DisplayName)
                if session.duration < 2 {
                    Text("\(session.duration) min")
                } else {
                    Text("\(session.duration) mins")
                }
            }
            Section {
                Text(session.notes.isEmpty ? "No notes" : session.notes)
            }
            Section {
                ForEach(session.sparringRounds) { round in
                    Text("Sparring (\(round.discipline.DisplayName))")
                    Text("Rounds: \(round.rounds) | Minutes Per Round: \(round.minutesPerRound)")
                    
                }
            }
        }
        .toolbar {
            Button("Edit") {
                showEdit = true
            }
        }
        .sheet(isPresented: $showEdit) {
            EditSessionView(session: session)
        }
    }
}

