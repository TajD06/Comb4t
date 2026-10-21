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
        NavigationStack {
            List {
                Section {
                    DisciplineSelector(selection: $discipline, compact: true)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                } header: {
                    Text("Discipline")
                }

                Section("Duration") {
                    DurationDial(minutes: $durationMins, colors: discipline.colors)
                        .padding(.vertical, 12)
                }
                .listRowBackground(Rectangle().fill(.regularMaterial))

                Section("When") {
                    DatePicker(selection: $date) {
                        Label("Date", systemImage: "calendar")
                    }
                }
                .listRowBackground(Rectangle().fill(.regularMaterial))

                Section("Notes") {
                    TextField("How did the session go?", text: $notes, axis: .vertical)
                        .lineLimit(3...8)
                }
                .listRowBackground(Rectangle().fill(.regularMaterial))

                Section("Sparring Rounds") {
                    if session.sparringRounds.isEmpty {
                        Text("No sparring logged")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(session.sparringRounds) { round in
                            SparringRoundRow(round: round)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let round = session.sparringRounds[index]
                                context.delete(round)
                            }
                        }
                    }
                }
                .listRowBackground(Rectangle().fill(.regularMaterial))

            }
            .scrollContentBackground(.hidden)
            .background {
                AmbientBackground(colors: discipline.colors)
                    .animation(.easeInOut(duration: 0.6), value: discipline)
            }
            .navigationTitle("Edit Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        session.date = date
                        session.discipline = discipline
                        session.duration = durationMins
                        session.notes = notes
                        dismiss()

                    }
                    .fontWeight(.semibold)
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
