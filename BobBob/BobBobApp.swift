import SwiftUI

@main
struct BobBobApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    // These must be StateObject — the source of truth
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
                    .environmentObject(mealStore)
                    .environmentObject(restActivityStore)
                    .environmentObject(activityStore)
                    .environmentObject(taskStore)
                    .environmentObject(scheduleVM)
                    .environmentObject(prefs)
                   
                
                    
            } else {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
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
