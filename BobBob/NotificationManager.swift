//
//  NotificationManager.swift
//  Timely
//
//  Created by Hanyi on 20/11/25.
//


import UserNotifications
import Foundation

final class NotificationManager {

    static let shared = NotificationManager()
    private init() {}

    // Request notification permission
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    // Clear all notifications
    func clearAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // Schedule single notification
    func schedule(id: String, title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: date
            ),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}
