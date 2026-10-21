//
//  ContentView.swift
//  Log app
//
//  Created by Amtaj Dhanoa on 2026-06-23.
//
import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var showSaveConfirmation = false
    @Environment(\.modelContext) private var context
    @State private var date: Date = .now
    @State private var discipline: Discipline = .striking
    @State private var durationMins: Int = 0
    @State private var notes: String = ""
    @State private var showSparring = false
    @State private var sparringRounds: [Sparring] = []
    @State private var draftSession: TrainingSession?
    
    func resetForm() {
        date = .now
        discipline = .striking
        durationMins = 0
        notes = ""
        showSparring = false
        sparringRounds = []
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()).uppercased())
                            .font(.caption.weight(.bold))
                            .tracking(1.2)
                            .foregroundStyle(.secondary)
                        Text("Log Session")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
                    .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 14) {
                        CardHeader(title: "Discipline", systemImage: "figure.martial.arts")
                        DisciplineSelector(selection: $discipline)
                    }
                    .card()

                    VStack(alignment: .leading, spacing: 16) {
                        CardHeader(title: "Duration", systemImage: "clock")
                        DurationDial(minutes: $durationMins, colors: discipline.colors)
                    }
                    .card()

                    VStack(alignment: .leading, spacing: 12) {
                        CardHeader(title: "When", systemImage: "calendar")
                        DatePicker("Date", selection: $date)
                            .font(.body.weight(.medium))
                    }
                    .card()

                    VStack(alignment: .leading, spacing: 14) {
                        CardHeader(title: "Sparring", systemImage: "stopwatch")

                        if !sparringRounds.isEmpty {
                            Text("\(sparringRounds.count) sparring round(s) logged")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            ForEach(sparringRounds) { round in
                                SparringRoundRow(round: round)
                            }
                        }

                        Button {
                            showSparring = true
                        } label: {
                            Label(sparringRounds.isEmpty ? "Log Sparring Rounds" : "Add More Rounds", systemImage: "plus")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 13)
                                .foregroundStyle(discipline.tint)
                                .background(discipline.tint.opacity(0.14), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                    .card()

                    VStack(alignment: .leading, spacing: 12) {
                        CardHeader(title: "Notes", systemImage: "note.text")
                        TextField("How did the session go?", text: $notes, axis: .vertical)
                            .lineLimit(3...8)
                    }
                    .card()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.interactively)
            .background {
                AmbientBackground(colors: discipline.colors)
                    .animation(.easeInOut(duration: 0.6), value: discipline)
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    showSaveConfirmation = true
                } label: {
                    Label("Save Session", systemImage: "checkmark")
                }
                .buttonStyle(GradientCapsuleButtonStyle(colors: discipline.colors))
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
                .alert("Save this session?", isPresented: $showSaveConfirmation) {
                    Button("Save") {
                        let session = TrainingSession(
                            date: date,
                            duration: durationMins,
                            discipline :discipline,
                            notes: notes
                        )
                        for sparring in sparringRounds {
                            sparring.session = session
                            session.sparringRounds.append(sparring)
                            context.insert(sparring)
                        }
                        context.insert(session)
                        print("Session saved with \(session.sparringRounds.count) sparring rounds")
                        resetForm()
                    }

                    Button("Cancel", role: .cancel) {}

                } message: {
                    Text("This will save your session to your log.")
                }
            }
            .navigationTitle("Log Session")
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showSparring) {
                SparringFormView { newRound in
                    sparringRounds.append(newRound)
                }
            }
        }
    }
}

#Preview {
    TabView {
        ContentView()
            .tabItem { Label("Log", systemImage: "square.and.pencil") }
        SessionCalendarView()
            .tabItem { Label("Calendar", systemImage: "calendar") }
    }
    .modelContainer(for: [TrainingSession.self, Sparring.self], inMemory: true)
}


