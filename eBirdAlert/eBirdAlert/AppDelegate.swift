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
        let hex = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("registered: \(hex)")
    }

    @MainActor
    func application(
        _: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: any Error
    ) {
        print("failed: \(error)")
    }
}
