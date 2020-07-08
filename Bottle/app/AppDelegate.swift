//
//  AppDelegate.swift
//  Bottle
//
//  Created by Vandilson Lima on 23/06/20.
//  Copyright © 2020 klsoft. All rights reserved.
//

import UIKit
import UserNotifications
import Intents
import Firebase
import GoogleMobileAds

struct ActionsIdentifiers {
    static let first = "first"
    static let second = "second"
    static let third = "third"
}

struct CategoryIdentifiers {
    static let reminder = "water-reminder"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestNotificationAuthorization()
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        return true
    }

    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            let settings = Settings.current
            settings.notification = granted
            settings.save()
            if granted {
                NotificationScheduler.shared.schedule()
                self.registerActions()
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func registerActions() {
        let size = Settings.current.cupSize

        let defaultAction = UNNotificationAction(identifier: ActionsIdentifiers.first, title: "Drink \(size) ml", options: [])
        let defaultAction1 = UNNotificationAction(identifier: ActionsIdentifiers.second, title: "Drink \(size + 50) ml", options: [])
        let defaultAction2 = UNNotificationAction(identifier: ActionsIdentifiers.third, title: "Drink \(size + 100) ml", options: [])

        let category = UNNotificationCategory(
            identifier: CategoryIdentifiers.reminder,
            actions: [defaultAction, defaultAction1, defaultAction2],
            intentIdentifiers: [],
            options: .customDismissAction
        )

        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([category])
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {

        let size = Settings.current.cupSize
        switch response.actionIdentifier {
        case ActionsIdentifiers.first:
            Bottle.shared.removeCup()
        case ActionsIdentifiers.second:
            Bottle.shared.removeCup(size: size + 50)
        case ActionsIdentifiers.third:
            Bottle.shared.removeCup(size: size + 100)
        default: break
        }

        NotificationCenter.default.post(
            Notification(name: Notification.Name(rawValue: "notification.response"))
        )

        completionHandler()
    }
}

