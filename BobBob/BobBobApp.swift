import SwiftUI
@main
struct BobBobApp: App {
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @StateObject var mealStore = MealTimeStore()
    @StateObject var restActivityStore = RestActivityStore()
    @StateObject var activityStore = ActivityStore()
    @StateObject var taskStore = TaskStore.shared
    @StateObject var scheduleVM = SchedulerViewModel()
    
    var body: some Scene {
        WindowGroup {
            let prefs = PreferencesStore.shared
            if hasSeenOnboarding {
                ContentView(hasSeenOnboarding: $hasSeenOnboarding)
                    .transition(.asymmetric(
                                    insertion: .move(edge: .trailing)
                                        .combined(with: .opacity)
                                        .combined(with: .scale(scale: 0.98)),
                                    removal: .move(edge: .leading)
                                        .combined(with: .opacity)
                                ))
                    .environmentObject(mealStore)
                    .environmentObject(restActivityStore)
                    .environmentObject(activityStore)
                    .environmentObject(taskStore)
                    .environmentObject(scheduleVM)
                    .environmentObject(prefs)
            } else {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .transition(.asymmetric(
                                    insertion: .move(edge: .trailing)
                                        .combined(with: .opacity)
                                        .combined(with: .scale(scale: 0.98)),
                                    removal: .move(edge: .leading)
                                        .combined(with: .opacity)
                                ))
                    .environmentObject(mealStore)
                    .environmentObject(restActivityStore)
                    .environmentObject(activityStore)
                    .environmentObject(taskStore)
                    .environmentObject(scheduleVM)
                    .environmentObject(prefs)
            }
        }
    }
}
