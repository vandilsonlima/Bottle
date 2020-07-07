//
//  NotificationScheduler.swift
//  Bottle
//
//  Created by Vandilson Lima on 05/07/20.
//  Copyright © 2020 klsoft. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationScheduler {
    static let shared = NotificationScheduler()

    func schedule() {
        removeAllPendingNotifications()

        let settings = Settings.current
        let calendar = Calendar.current

        let start = settings.wakeupTime
        let end = settings.sleepTime

        let diffComponents = calendar.dateComponents([.minute], from: start, to: end)

        let diff = abs(diffComponents.minute!)

        let cups = settings.dailyGoal / settings.cupSize
        let interval = diff / cups

        for i in stride(from: 0, through: diff, by: interval) {
            let newDate = calendar.date(byAdding: .minute, value: i, to: start)!
            let components = calendar.dateComponents([.hour, .minute, .second], from: newDate)
            addNotification(for: components)
        }
    }

    func addNotification(for components: DateComponents) {
        let center = UNUserNotificationCenter.current()
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = "Stay hydrated!"
        content.body = "It's time to drink water"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = "water-reminder"

        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request, withCompletionHandler: nil)
        print("scheduled for \(components)")
    }

    func removeAllPendingNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }

    func testNotification() {
        let center = UNUserNotificationCenter.current()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = "Stay hydrated!"
        content.body = "It's time to drink water"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = "water-reminder"

        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request, withCompletionHandler: nil)
    }
}
