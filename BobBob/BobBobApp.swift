import SwiftUI
@main
struct BobBobApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    @StateObject var mealStore = MealTimeStore()
    @StateObject var restActivityStore = RestActivityStore()
    @StateObject var activityStore = ActivityStore()
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView(hasSeenOnboarding: $hasSeenOnboarding)
                    .environmentObject(mealStore)
                    .environmentObject(restActivityStore)
                    .environmentObject(activityStore)
            } else {

                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .environmentObject(mealStore)
                    .environmentObject(restActivityStore)
                    .environmentObject(activityStore)
            }
        }
    }
}
