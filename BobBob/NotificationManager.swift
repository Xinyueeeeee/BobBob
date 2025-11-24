//
//  NotificationManager.swift
//  Timely
//
//  Created by Hanyi on 20/11/25.
//

import Foundation
import UserNotifications
import SwiftUI

final class NotificationManager: ObservableObject {

    static let shared = NotificationManager()
    @Published var showDeniedAlert = false

    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                DispatchQueue.main.async {
                    if !granted {
                        self.showDeniedAlert = true
                    }
                }
            }
    }

    func clearAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

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

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
extension NotificationManager {
    func requestPermissionAndUpdate(_ binding: Binding<Bool>) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                if !granted {
                    binding.wrappedValue = false
                    self.showDeniedAlert = true
                }
            }
        }
    }
}
