//
//  settingsView.swift
//  BobBob
//
//  Created by minyi on 14/11/25.
//


import SwiftUI

struct SettingsView: View {
    @Binding var hasSeenOnboarding: Bool

    // Shared persistent stores
    @EnvironmentObject var mealStore: MealTimeStore
    @StateObject var scheduleVM = SchedulerViewModel()

    @StateObject private var restActivityStore = RestActivityStore()

    var body: some View {
        NavigationStack {
            Form {

                // --------------------
                // General
                // --------------------
                Section(header: Text("General")) {
                    NavigationLink {
                        NotifsView()
                    } label: {
                        Text("Notifications")
                    }
                }

                // --------------------
                // Integrations
                // --------------------
                Section(header: Text("Integrations")) {
                    NavigationLink {
                        NotifsView()
                    } label: {
                        Text("Apple Calendar")
                    }
                }

                // --------------------
                // Personal Info
                // --------------------
                Section(header: Text("Personal Information")) {
                    
                    NavigationLink {
                        ChronotypeView2(hasSeenOnboarding: $hasSeenOnboarding)
                    } label: {
                        Text("Chronotype")
                    }
                    
                    NavigationLink {
                        MealTimeView2(hasSeenOnboarding: $hasSeenOnboarding)
                            .environmentObject(mealStore)   // ← ADD THIS
                    } label: {
                        Text("Meal Time")
                    }
                    
                    
                    NavigationLink {
                        NapTimeView2(hasSeenOnboarding: $hasSeenOnboarding)
                            .environmentObject(scheduleVM)
                    } label: {
                        Text("Sleep Schedule")
                    }
                    
                    NavigationLink {
                        ActivitiesView2(hasSeenOnboarding: $hasSeenOnboarding)
                    } label: {
                        Text("Activity")
                    }
                    
                    NavigationLink {
                        RestDaysView2(hasSeenOnboarding: $hasSeenOnboarding)
                            .environmentObject(restActivityStore)
                    } label: {
                        Text("Rest Day")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView(hasSeenOnboarding: .constant(false))
}


struct NotifsView: View {
    @AppStorage("startOfTasks") private var startOfTasks: Bool = false
    @AppStorage("endOfTasks") private var endOfTasks: Bool = false
    @AppStorage("fiveMinBefTask") private var fiveMinBefTask: Bool = false

    var body: some View {
        NavigationStack {
            List {
                Toggle(isOn: $startOfTasks) {
                    Text("At the start of the task")
                }
                Toggle(isOn: $endOfTasks) {
                    Text("At the end of the tasks")
                }
                Toggle(isOn: $fiveMinBefTask) {
                    Text("5 minutes before task")
                }
            }
            .navigationTitle("Notifications")
        }
    }
}

