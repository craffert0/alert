// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI

protocol NotificationService: Sendable {
    func notify(_ deviceId: String,
                deviceType: Components.Schemas.DeviceType,
                newBirds: Set<String>,
                badgeCount: Int) async throws
}
