class RestActivityStore: ObservableObject {
    @Published var activities: [RestActivity] = [] {
        didSet { saveActivities() }
    }

    private let storageKey = "savedRestActivities"

    init() {
        loadActivities()
    }

    private func loadActivities() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        if let decoded = try? JSONDecoder().decode([RestActivity].self, from: data) {
            self.activities = decoded
        }
    }

    private func saveActivities() {
        if let encoded = try? JSONEncoder().encode(activities) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
}
