import SwiftUI

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
