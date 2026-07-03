//
//  SessionHistoryView.swift
//  Log app
//
//  Created by Amtaj Dhanoa on 2026-06-28.
//

import FSCalendar
import SwiftUI
import UIKit
import SwiftData

struct FSCalendarView: UIViewRepresentable {
    @Binding var selectedDate: Date
    var sessions: [TrainingSession]

    func makeCoordinator() -> Coordinator {
        Coordinator(self, sessions: sessions)
    }

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.appearance.weekdayTextColor = .label
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.headerTitleColor = .label
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.appearance.selectionColor = .systemCyan
        calendar.today = nil
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        context.coordinator.sessions = sessions
        uiView.reloadData()
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, FSCalendarDataSource, FSCalendarDelegate {
        var parent: FSCalendarView
        var sessions: [TrainingSession]

        init(_ calendar: FSCalendarView, sessions: [TrainingSession]) {
            self.parent = calendar
            self.sessions = sessions
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            calendar.reloadData()
            parent.selectedDate = date
        }

        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            let count = sessions.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }.count
            print("Events for \(date): \(count), total sessions: \(sessions.count)")
            return count
        }

        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            calendar.reloadData()
        }
    }
}
