//
//  settingsView.swift
//  BobBob
//
//  Created by minyi on 14/11/25.
//
import SwiftUI

struct SettingsView: View {
    @Binding var hasSeenOnboarding: Bool
    @StateObject private var notificationManager = NotificationManager.shared
    @EnvironmentObject var mealStore: MealTimeStore
    @EnvironmentObject var restActivityStore: RestActivityStore
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var scheduleVM: SchedulerViewModel
    @EnvironmentObject var prefs: PreferencesStore

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.2),
                        Color.blue.opacity(0.6)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                Form {
                    Section(header: Text("General")) {
                        NavigationLink { NotifsView() } label: {
                            Text("Notifications")
                        }
                    }

                    Section(header: Text("Personal Information")) {
                        NavigationLink { ChronotypeView2(hasSeenOnboarding: $hasSeenOnboarding) } label: { Text("Chronotype") }
                        NavigationLink { NapTimeView2(hasSeenOnboarding: $hasSeenOnboarding) } label: { Text("Sleep Schedule") }
                        NavigationLink { MealTimeView2(hasSeenOnboarding: $hasSeenOnboarding) } label: { Text("Meal Time") }
                        NavigationLink { ActivitiesView2(hasSeenOnboarding: $hasSeenOnboarding) } label: { Text("Activity") }
                        NavigationLink { RestDaysView2(hasSeenOnboarding: $hasSeenOnboarding) } label: { Text("Rest Day") }
                    }
                }
                .scrollContentBackground(.hidden)
                .alert("Notifications Disabled", isPresented: $notificationManager.showDeniedAlert) {
                    Button("Open Settings") {
                        notificationManager.openSettings()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("To enable notifications, allow notifications in system settings.")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView(hasSeenOnboarding: .constant(false))
}


import SwiftUI

struct NotifsView: View {
    @AppStorage("startOfTasks") private var startOfTasks: Bool = false
    @AppStorage("endOfTasks") private var endOfTasks: Bool = false
    @AppStorage("fiveMinBefTask") private var fiveMinBefTask: Bool = false

    @EnvironmentObject var scheduleVM: SchedulerViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.2),
                        Color.blue.opacity(0.6)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                List {
                    Toggle("5 minutes before task", isOn: $fiveMinBefTask)
                        .onChange(of: fiveMinBefTask) { newValue in
                            if newValue {
                                NotificationManager.shared.requestPermissionAndUpdate($fiveMinBefTask)
                            }
                            scheduleVM.refreshNotifications()
                        }

                    Toggle("At the start of the task", isOn: $startOfTasks)
                        .onChange(of: startOfTasks) { newValue in
                            if newValue {
                                NotificationManager.shared.requestPermissionAndUpdate($startOfTasks)
                            }
                            scheduleVM.refreshNotifications()
                        }

                    Toggle("At the end of the tasks", isOn: $endOfTasks)
                        .onChange(of: endOfTasks) { newValue in
                            if newValue {
                                NotificationManager.shared.requestPermissionAndUpdate($endOfTasks)
                            }
                            scheduleVM.refreshNotifications()
                        }

                }
                .scrollContentBackground(.hidden)
                .listRowBackground(Color.clear)
                .navigationTitle("Notifications")
            }
        }
    }
}
