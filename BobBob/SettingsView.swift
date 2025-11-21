//
//  settingsView.swift
//  BobBob
//
//  Created by minyi on 14/11/25.
//
import SwiftUI
struct SettingsView: View {
    @Binding var hasSeenOnboarding: Bool

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
                        NavigationLink {
                            ChronotypeView2(hasSeenOnboarding: $hasSeenOnboarding)
                        } label: { Text("Chronotype") }

                        NavigationLink {
                            MealTimeView2(hasSeenOnboarding: $hasSeenOnboarding)
                        } label: { Text("Meal Time") }

                        NavigationLink {
                            NapTimeView2(hasSeenOnboarding: $hasSeenOnboarding)
                        } label: { Text("Sleep Schedule") }

                        NavigationLink {
                            ActivitiesView2(hasSeenOnboarding: $hasSeenOnboarding)
                        } label: { Text("Activity") }

                        NavigationLink {
                            RestDaysView2(hasSeenOnboarding: $hasSeenOnboarding)
                        } label: { Text("Rest Day") }
                    }
                }
                .scrollContentBackground(.hidden) // 👈 makes Form transparent over gradient
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

    @EnvironmentObject var scheduleVM: SchedulerViewModel

    var body: some View {
        NavigationStack {
            List {
                Toggle(isOn: $startOfTasks) {
                    Text("At the start of the task")
                }
                .onChange(of: startOfTasks) {
                    NotificationManager.shared.requestPermission()
                    scheduleVM.refreshNotifications()
                }

                Toggle(isOn: $endOfTasks) {
                    Text("At the end of the tasks")
                }
                .onChange(of: endOfTasks) {
                    NotificationManager.shared.requestPermission()
                    scheduleVM.refreshNotifications()
                }

                Toggle(isOn: $fiveMinBefTask) {
                    Text("5 minutes before task")
                }
                .onChange(of: fiveMinBefTask) {
                    NotificationManager.shared.requestPermission()
                    scheduleVM.refreshNotifications()
                }
            }
            .navigationTitle("Notifications")
        }
    }
}
