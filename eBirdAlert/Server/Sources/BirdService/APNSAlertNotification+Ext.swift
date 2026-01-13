// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import APNSCore

extension APNSAlertNotification<NotificationPayload> {
    init(newBirds: Set<String>, badgeCount: Int) {
        self.init(
            alert: .init(newBirds: newBirds),
            expiration: .immediately,
            priority: .immediately,
            topic: "net.rafferty.colin.eBirdAlert",
            payload: NotificationPayload(),
            badge: badgeCount
        )
        collapseID = "just one"
    }
}
