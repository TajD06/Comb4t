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
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section {
                        DatePicker("Date", selection: $date)
                    }
                    
                    Section {
                        Picker("Discipline", selection: $discipline) {
                            Text("Striking").tag(Discipline.striking)
                            Text("Grappling").tag(Discipline.grappling)
                            Text("MMA").tag(Discipline.MMA)
                        }
                        
                        Picker("Duration", selection: $durationMins) {
                            ForEach(Array(stride(from: 0, to: 305, by: 1)), id: \.self) { mins in
                                Text("\(mins) mins").tag(mins)
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        TextField("Notes", text: $notes, axis: .vertical)
                        
                        Button("Log Sparring Rounds") {
                            showSparring = true
                        }
                        if sparringRounds.isEmpty {
                            Text("\(sparringRounds.count) sparring round(s) logged")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                        
                    }
                    
                }
                .scrollDismissesKeyboard(.interactively)
                
                VStack{
                    Spacer()
                    Button("Save") {
                        showSaveConfirmation = true
                    }
                    .padding(.horizontal, 35)
                    .padding(.vertical, 20)
                    .background(.blue)
                    .foregroundStyle(Color.white)
                    .clipShape(Capsule())
                    .shadow(radius: 7)
                    .padding(.bottom, 20)
                    
                    
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
            }
            .navigationTitle("Log a session")
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
               .tabItem { Label("Log", systemImage: "plus.circle") }
           SessionCalendarView()
               .tabItem { Label("Calendar", systemImage: "calendar") }
       }
       .modelContainer(for: [TrainingSession.self, Sparring.self], inMemory: true)
   }


