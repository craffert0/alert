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
            .init(newBirds: newBirds, badgeCount: badgeCount),
            deviceToken: deviceId
        )
    }
}
