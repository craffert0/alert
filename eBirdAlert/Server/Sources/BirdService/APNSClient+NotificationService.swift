// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import APNS
import Foundation

extension APNSClient<JSONDecoder, JSONEncoder>: NotificationService {
    func notify(_ deviceId: String,
                newBirds: Set<String>,
                badgeCount: Int) async throws
    {
        try await sendAlertNotification(
            .init(
                alert: .init(
                    title: .raw(newBirds.count == 1 ? "New Rarity" : "New Rarities"),
                    body: .raw(newBirds.joined(separator: ", ")),
                    launchImage: nil
                ),
                expiration: .immediately,
                priority: .immediately,
                topic: "net.rafferty.colin.eBirdAlert",
                payload: NotificationPayload(),
                badge: badgeCount
            ),
            deviceToken: deviceId
        )
    }
}
