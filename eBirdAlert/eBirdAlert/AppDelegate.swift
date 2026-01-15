// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import UIKit
import UserNotifications

class AppDelegate: NSObject {
    private let center = NotificationCenter.default
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        if let tabKind = response.notification.request.content.tabKind {
            center.post(name: .navigateToTab, object: tabKind)
        }
        completionHandler()
    }

    func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent _: UNNotification
    ) async -> UNNotificationPresentationOptions {
        // let c = notification.request.content
        // print(c.title, c.body)
        // if let badge = c.badge {
        //     setBadgeOnNotables(badge)
        // }
        .banner
    }
}

extension AppDelegate: UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions _:
        [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        return true
    }

    @MainActor
    func application(
        _: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        PreferencesModel.global.deviceToken = deviceToken
    }

    @MainActor
    func application(
        _: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError _: any Error
    ) {
        PreferencesModel.global.deviceToken = nil
    }
}
