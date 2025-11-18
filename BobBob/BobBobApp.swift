import SwiftUI
@main
struct BobBobApp: App {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    
    var body: some Scene {
        WindowGroup {
            if isWelcomeScreenOver {
                ContentView()
            } else {
                RestDaysView()
            }
        }
    }
}
