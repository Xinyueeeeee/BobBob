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
    @State private var selectedTab = 1

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.stackedLayoutAppearance.normal.iconColor = .black
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]

        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {

            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }
                .tag(0)

            TasksView()
                .tabItem { Label("Tasks", systemImage: "list.bullet") }
                .tag(1)   

            SettingsView(hasSeenOnboarding: .constant(false))
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(2)
        }
    }
}



#Preview {
    ContentView(hasSeenOnboarding:.constant(false))
}
