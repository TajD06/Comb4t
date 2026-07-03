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
    
    func deleteSession(at offsets: IndexSet) {
        for index in offsets {
            let session = sessionsOnSelectedDate[index]
            context.delete(session)
        }
    }
    
    
    var body: some View {
        let _ = print("Total sessions from Query: \(sessions.count)")
        NavigationStack {
            VStack {
                FSCalendarView(selectedDate: $selectedDate, sessions: sessions)
                    .frame(height: 250)
                
                Divider()
                
                if sessionsOnSelectedDate.isEmpty {
                    ContentUnavailableView("No Sessions", systemImage: "figure.martial.arts", description: Text("No sessions logged on this day."))
                } else {
                    List {
                        ForEach(sessionsOnSelectedDate) { session in
                            
                            NavigationLink(destination: SessionDetailView(session: session)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(session.discipline.rawValue.capitalized)
                                        .font(.headline)
                                    Text("\(session.duration) min")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    if !session.notes.isEmpty {
                                        Text(session.notes)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete { indexSet in
                            deleteSession(at: indexSet)
                        }
                    }
                    .navigationTitle("Training Calendar")
                }
            }
        }
    }
}
    
    
    #Preview {
        FSCalendarView(selectedDate: .constant(Date()), sessions: [])
    }

