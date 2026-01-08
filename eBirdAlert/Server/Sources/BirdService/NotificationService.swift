// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

protocol NotificationService: Sendable {
    func notify(_ deviceId: String, newBirds: Set<String>) async throws
}
