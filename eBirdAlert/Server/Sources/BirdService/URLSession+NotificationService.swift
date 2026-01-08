// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation

extension URLSession: NotificationService {
    func notify(_ deviceId: String, newBirds: Set<String>) async throws {
        // TODO: do it!
        print(deviceId)
        print(newBirds)
    }
}
