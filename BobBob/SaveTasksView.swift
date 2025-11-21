//
//  SaveTasksView.swift
//  BobBob
//
//  Created by Huang Qing on 15/11/25.
//
import Foundation

struct Task: Identifiable, Codable {
    var id = UUID()
    var name: String
    var deadline: Date
    var durationSeconds: Int
    var importance: Double
    var startDate: Date?
    var endDate: Date?
    var isCompleted: Bool = false
}
