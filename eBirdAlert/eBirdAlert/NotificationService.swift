// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import UserNotifications

class NotificationService {
    let birds = [
        "American Pipit",
        "Bald Eagle",
        "Black & White Warbler",
        "Greater Scaup",
    ]
    var bird = 0

    func fakeNotify() async {
        bird = (bird + 1) % birds.count
        let content = UNMutableNotificationContent()
        content.title = "New Rarity"
        content.body = birds[bird]
        content.sound = UNNotificationSound.default
        content.launchImageName = "Rarities"
        // content.badge = NSNumber(value: bird)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)

        let center = UNUserNotificationCenter.current()
        try? await center.add(request)
    }
}
