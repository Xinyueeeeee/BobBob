//
//  DataStores.swift
//  BobBob
//
//  Created by Hanyi on 19/11/25.
//
import Foundation
import Combine

final class TaskStore: ObservableObject {
    static let shared = TaskStore()
    @Published var tasks: [Task] = [] {
        didSet { save() }
    }
    private init() {
        load()
    }
    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("tasks.json")
    }
    private func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode([Task].self, from: data)
            self.tasks = decoded
        } catch {
            self.tasks = []
        }
    }
    private func save() {
        do {
            let data = try JSONEncoder().encode(tasks)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save tasks:", error)
        }
    }
}
final class PreferencesStore: ObservableObject {
    static let shared = PreferencesStore()
    @Published var meals: [MealTime] = []
    @Published var activities: [Activity] = []
    @Published var restActivities: [RestActivity] = []
    private init() { }
    @Published var chronotype: String = UserDefaults.standard.string(forKey: "selectedChronotype") ?? "Early Bird" {
        didSet { UserDefaults.standard.set(chronotype, forKey: "selectedChronotype") }
    }

}
