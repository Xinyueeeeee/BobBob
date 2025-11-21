import SwiftUI
struct Task: Identifiable, Codable {
    var id: UUID
    var name: String
    var deadline: Date
    var durationSeconds: Int
    var importance: Double
    var startDate: Date?
    var endDate: Date?
    var isCompleted: Bool = false

    init(
        id: UUID = UUID(),
        name: String,
        deadline: Date,
        durationSeconds: Int,
        importance: Double,
        startDate: Date? = nil,
        endDate: Date? = nil,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.name = name
        self.deadline = deadline
        self.durationSeconds = durationSeconds
        self.importance = importance
        self.startDate = startDate
        self.endDate = endDate
        self.isCompleted = isCompleted
    }
}
