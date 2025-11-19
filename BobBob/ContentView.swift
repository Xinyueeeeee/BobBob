//
//  ContentView.swift
//  BobBob
//
//  Created by Huang Qing on 14/11/25.
//


import SwiftUI

struct ContentView: View {
    @Binding var hasSeenOnboarding: Bool
    var body: some View {
        MainTabView()
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }

            TasksView()
                .tabItem { Label("Tasks", systemImage: "list.bullet") }

            SettingsView(hasSeenOnboarding: .constant(false))
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}

#Preview {
    ContentView(hasSeenOnboarding:.constant(false))
}
