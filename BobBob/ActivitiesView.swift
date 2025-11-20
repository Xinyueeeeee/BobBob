import SwiftUI

struct ActivitiesView2: View {
    @EnvironmentObject var activityStore: ActivityStore
    @Binding var hasSeenOnboarding: Bool

    @State private var showingAdd = false
    @State private var editingActivity: Activity? = nil

    var body: some View {
        NavigationStack {
            ZStack {

                // SAME BACKGROUND AS REST DAYS
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 20) {

                    Text("Recurring Activities")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.top)

                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 15) {
                            ForEach(activityStore.activities) { activity in
                                activityRow(activity)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top, 10)
                    }

                    Spacer(minLength: 80)
                }

                // SAME BOTTOM-LEFT BUTTON
                VStack {
                    Spacer()
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
                        .padding(.leading, 25)
                        .padding(.bottom, 25)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Activities")
            .sheet(isPresented: $showingAdd) {
                AddActivitiesView(activity: nil) { new in
                    activityStore.activities.append(new)
                }
            }
            .sheet(item: $editingActivity) { act in
                AddActivitiesView(activity: act) { updated in
                    if let i = activityStore.activities.firstIndex(where: { $0.id == updated.id }) {
                        activityStore.activities[i] = updated
                    }
                }
            }
        }
    }

    // MARK: - Swipeable Row (same style as RestDaysView2)
    func activityRow(_ activity: Activity) -> some View {
        SwipeableCard(onDelete: {
            deleteActivity(activity)
        }) {

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
            .buttonStyle(.plain)
        }
    }

    func deleteActivity(_ activity: Activity) {
        if let i = activityStore.activities.firstIndex(where: { $0.id == activity.id }) {
            activityStore.activities.remove(at: i)
        }
    }
}
