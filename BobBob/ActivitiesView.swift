import SwiftUI

struct ActivitiesView2: View {
    @EnvironmentObject var activityStore: ActivityStore
    @Binding var hasSeenOnboarding: Bool
    @EnvironmentObject var preferenceStore: PreferencesStore
    @State private var showingAdd = false
    @State private var editingActivity: Activity? = nil

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
                
                VStack(spacing: 20) {
                    if preferenceStore.activities.isEmpty {
                        ContentUnavailableView(
                            "No Activities",
                            systemImage: "figure.walk",
                            description: Text("Add your recurring activities to schedule them.")
                        )
                    }

                    

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
                VStack {
                    Spacer()
                    
                }
            }
            .navigationTitle("Activities")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)       
                    }
                }
            }


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
    func activityRow(_ activity: Activity) -> some View {
        HStack {
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
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)

            Button {
                deleteActivity(activity)
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(8)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
    }

    func deleteActivity(_ activity: Activity) {
        if let i = activityStore.activities.firstIndex(where: { $0.id == activity.id }) {
            activityStore.activities.remove(at: i)
        }
    }
}
