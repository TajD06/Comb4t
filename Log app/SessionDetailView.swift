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
        ScrollView {
            VStack(spacing: 16) {
                ZStack(alignment: .bottomLeading) {
                    session.discipline.gradient

                    Image(systemName: session.discipline.symbolName)
                        .font(.system(size: 160, weight: .bold))
                        .foregroundStyle(.white.opacity(0.16))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .offset(x: 24, y: -8)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(session.date.formatted(.dateTime.weekday(.wide).month(.wide).day()).uppercased())
                            .font(.caption.weight(.bold))
                            .tracking(1.2)
                            .opacity(0.85)
                        Text(session.discipline.DisplayName)
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                        Label(session.date.formatted(date: .omitted, time: .shortened), systemImage: "clock")
                            .font(.subheadline.weight(.medium))
                            .opacity(0.9)
                    }
                    .foregroundStyle(.white)
                    .padding(22)
                }
                .frame(height: 210)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: session.discipline.tint.opacity(0.35), radius: 20, y: 10)

                HStack(spacing: 10) {
                    StatTile(
                        value: "\(session.duration)",
                        unit: session.duration < 2 ? "min" : "mins",
                        label: "Duration",
                        systemImage: "clock.fill",
                        tint: session.discipline.tint
                    )
                    StatTile(
                        value: "\(session.sparringRounds.reduce(0) { $0 + $1.rounds })",
                        label: "Rounds",
                        systemImage: "repeat",
                        tint: session.discipline.colors[1]
                    )
                    StatTile(
                        value: "\(session.sparringRounds.reduce(0) { $0 + $1.rounds * $1.minutesPerRound })",
                        unit: "min",
                        label: "Sparring",
                        systemImage: "stopwatch.fill",
                        tint: Brand.purple
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    CardHeader(title: "Notes", systemImage: "note.text")
                    Text(session.notes.isEmpty ? "No notes" : session.notes)
                        .foregroundStyle(session.notes.isEmpty ? .secondary : .primary)
                }
                .card()

                VStack(alignment: .leading, spacing: 14) {
                    CardHeader(title: "Sparring", systemImage: "stopwatch")
                    if session.sparringRounds.isEmpty {
                        Text("No sparring logged")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(session.sparringRounds) { round in
                        SparringRoundRow(round: round)
                    }
                }
                .card()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(AmbientBackground(colors: session.discipline.colors))
        .navigationBarTitleDisplayMode(.inline)
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
