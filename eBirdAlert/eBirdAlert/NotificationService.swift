// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import UserNotifications

@Observable
class NotificationService {
    private var center = UNUserNotificationCenter.current()

    func notify(for birds: [String], badge: Int) async throws {
        let request = try await UNNotificationRequest(
            identifier: UUID().uuidString,
            content: .with(birds, badge: badge),
            trigger: .eBird
        )

        try await center.add(request)
    }

    func clearBadgeCount() async throws {
        try await center.setBadgeCount(0)
    }
}

extension UNNotificationTrigger {
    static var eBird =
        UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                          repeats: false)
}

extension UNNotificationContent {
    static func with(_ birds: [String], badge: Int) async throws
        -> UNNotificationContent
    {
        let content = UNMutableNotificationContent()
        content.title = birds.count == 1 ? "New Rarity" : "New Rarities"
        content.body = birds.notificationFormat
        content.sound = UNNotificationSound.default
        content.targetContentIdentifier = "Rarities"
        content.badge = NSNumber(value: badge)
        content.userInfo = [.kTabName: TabKind.rarities.rawValue]
        return content
    }

    var tabKind: TabKind? {
        guard let tabName = userInfo[.kTabName] as? String else { return nil }
        return TabKind(rawValue: tabName)
    }
}
