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
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 14) {
                        CardHeader(title: "Discipline", systemImage: "figure.martial.arts")
                        DisciplineSelector(selection: $discipline, compact: true)
                    }
                    .card()

                    HStack(spacing: 12) {
                        CounterCard(title: "Rounds", systemImage: "repeat", value: $rounds, range: 0...20)
                        CounterCard(title: "Per Round", systemImage: "timer", value: $mins, range: 0...10, unit: "min")
                    }

                    HStack {
                        Label("Total sparring", systemImage: "stopwatch")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(rounds * mins) min")
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .monospacedDigit()
                            .contentTransition(.numericText(value: Double(rounds * mins)))
                            .animation(.snappy, value: rounds * mins)
                    }
                    .card()
                }
                .padding(16)
            }
            .background {
                AmbientBackground(colors: discipline.colors)
                    .animation(.easeInOut(duration: 0.6), value: discipline)
            }
            .navigationTitle("Sparring")
            .navigationBarTitleDisplayMode(.inline)
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
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.fraction(0.65), .large])
    }
}
