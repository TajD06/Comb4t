//
//  LogApp.swift
//  Log app
//
//  Created by Amtaj Dhanoa on 2026-06-23.
//

import SwiftUI
import SwiftData

@main
struct Log_appApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem{
                        Label("Log", systemImage: "plus.circle")
                    }
                SessionCalendarView()
                    .tabItem{
                        Label("Calendar", systemImage: "calendar")
                    }
            }
        }
        .modelContainer(for: TrainingSession.self)
    }
}
 

