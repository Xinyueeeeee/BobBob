//
//  ActivitiesView.swift
//  BobBob
//
//  Created by Hanyi on 17/11/25.
//


import SwiftUI
struct ActivitiesView2: View {
    @EnvironmentObject var activityStore: ActivityStore
    @Binding var hasSeenOnboarding: Bool

    @State private var showingAdd = false
    @State private var editingActivity: Activity? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Text("Recurring Activities")
                    .font(.headline)
                    .foregroundColor(.black.opacity(0.5))

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(activityStore.activities) { activity in
                            Button {
                                editingActivity = activity
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(activity.name)
                                        .font(.headline)
                                        .foregroundColor(.black)

                                    HStack {
                                        Label(activity.day, systemImage: "calendar")
                                        Label(activity.regularity, systemImage: "repeat")
                                        Label(activity.timeFormatted, systemImage: "clock")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }

                Spacer()

                // Bottom-left Add Button
                HStack {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }

                    Spacer()
                }
                .padding(.leading, 25)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Activities")
        .sheet(isPresented: $showingAdd) {
            AddActivitiesView(activity: nil) { new in
                activityStore.activities.append(new)
            }
        }
        .sheet(item: $editingActivity) { activity in
            AddActivitiesView(activity: activity) { updated in
                if let i = activityStore.activities.firstIndex(where: { $0.id == updated.id }) {
                    activityStore.activities[i] = updated
                }
            }
        }
    }
}

class ActivityStore: ObservableObject {
    @Published var activities: [Activity] = [] {
        didSet { saveActivities() }
    }

    private let storageKey = "savedActivities"

    init() {
        loadActivities()
    }

    private func loadActivities() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        if let decoded = try? JSONDecoder().decode([Activity].self, from: data) {
            self.activities = decoded
        }
    }

    private func saveActivities() {
        if let encoded = try? JSONEncoder().encode(activities) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
}

