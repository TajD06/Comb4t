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
    @State private var selectedTab = 0

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                ContentView()
                    .tabItem{
                        Label("Log", systemImage: "square.and.pencil")
                    }
                    .tag(0)
                SessionCalendarView()
                    .tabItem{
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tag(1)
            }
            // Each tab lights up in its own brand colour.
            .tint(selectedTab == 0 ? Brand.purple : Brand.pink)
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
        }
        .modelContainer(for: TrainingSession.self)
    }
}
