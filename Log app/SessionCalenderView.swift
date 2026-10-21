//
//  SessionCalenderView.swift
//  Log app
//
//  Created by Amtaj Dhanoa on 2026-06-28.
//

import SwiftUI
import SwiftData

struct SessionCalendarView: View {
    @Query(sort: \TrainingSession.date, order: .reverse) var sessions: [TrainingSession]
    @State private var selectedDate: Date = .now
    @Environment(\.modelContext) private var context
    
    var sessionsOnSelectedDate: [TrainingSession] {
        sessions.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    private var monthSessions: [TrainingSession] {
        sessions.filter { Calendar.current.isDate($0.date, equalTo: selectedDate, toGranularity: .month) }
    }

    private var monthHours: String {
        let minutes = monthSessions.reduce(0) { $0 + $1.duration }
        return String(format: "%.1f", Double(minutes) / 60)
    }

    private var monthRounds: Int {
        monthSessions.reduce(0) { total, session in
            total + session.sparringRounds.reduce(0) { $0 + $1.rounds }
        }
    }

    func deleteSession(at offsets: IndexSet) {
        for i in offsets {
            let session = sessionsOnSelectedDate[i]
            context.delete(session)
        }
    }
    
    
    var body: some View {
        let _ = print("Total sessions from Query: \(sessions.count)")
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 10) {
                        StatTile(value: "\(monthSessions.count)", label: "Sessions", systemImage: "flame.fill", tint: .orange)
                        StatTile(value: monthHours, unit: "h", label: "Trained", systemImage: "clock.fill", tint: Brand.purple)
                        StatTile(value: "\(monthRounds)", label: "Rounds", systemImage: "stopwatch.fill", tint: Brand.pink)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                } header: {
                    Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                }

                Section {
                    FSCalendarView(selectedDate: $selectedDate, sessions: sessions)
                        .frame(height: 300)
                        .padding(.vertical, 4)
                        .listRowBackground(Rectangle().fill(.regularMaterial))
                }

                Section {
                    if sessionsOnSelectedDate.isEmpty {
                        ContentUnavailableView("No Sessions", systemImage: "figure.martial.arts", description: Text("No sessions logged on this day."))
                            .listRowBackground(Color.clear)
                    } else {
                        ForEach(sessionsOnSelectedDate) { session in

                            NavigationLink(destination: SessionDetailView(session: session)) {
                                HStack(spacing: 14) {
                                    DisciplineBadge(discipline: session.discipline, size: 46)

                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack(alignment: .firstTextBaseline) {
                                            Text(session.discipline.rawValue.capitalized)
                                                .font(.headline)
                                            Spacer()
                                            Text(session.date.formatted(date: .omitted, time: .shortened))
                                                .font(.caption.weight(.semibold))
                                                .foregroundStyle(.secondary)
                                        }
                                        HStack(spacing: 6) {
                                            MetaPill(text: "\(session.duration) min", systemImage: "clock")
                                            if !session.sparringRounds.isEmpty {
                                                MetaPill(text: "\(session.sparringRounds.count) sparring", systemImage: "stopwatch")
                                            }
                                        }
                                        if !session.notes.isEmpty {
                                            Text(session.notes)
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                                .lineLimit(1)
                                        }
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                            .listRowBackground(Rectangle().fill(.regularMaterial))
                        }
                        .onDelete { indexSet in
                            deleteSession(at: indexSet)
                        }
                    }
                } header: {
                    Text(selectedDate.formatted(date: .complete, time: .omitted))
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(AmbientBackground())
            .navigationTitle("Training")
        }
    }
}
    
    
    #Preview {
        FSCalendarView(selectedDate: .constant(Date()), sessions: [])
    }

