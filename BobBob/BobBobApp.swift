import SwiftUI

@main
struct BobBobApp: App {

    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    @StateObject var mealStore = MealTimeStore()
    @StateObject var restActivityStore = RestActivityStore()
    @StateObject var activityStore = ActivityStore()
    @StateObject var taskStore = TaskStore.shared
    @StateObject var scheduleVM = SchedulerViewModel()
    @StateObject var prefs = PreferencesStore.shared

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {

                ContentView(hasSeenOnboarding: $hasSeenOnboarding)
                    .environmentObject(mealStore)
                    .environmentObject(restActivityStore)
                    .environmentObject(activityStore)
                    .environmentObject(taskStore)
                    .environmentObject(scheduleVM)
                    .environmentObject(prefs)
                    .onAppear {
                        prefs.bind(
                            mealStore: mealStore,
                            activityStore: activityStore,
                            restStore: restActivityStore
                        )
                    }

            } else {

                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .environmentObject(mealStore)
                    .environmentObject(restActivityStore)
                    .environmentObject(activityStore)
                    .environmentObject(taskStore)
                    .environmentObject(scheduleVM)
                    .environmentObject(prefs)
                    .onAppear {
                        prefs.bind(
                            mealStore: mealStore,
                            activityStore: activityStore,
                            restStore: restActivityStore
                        )
                    }
            }
        }
    }
}
