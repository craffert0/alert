// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

struct NotableObservationsClient {
    var observations: [eBirdObservation] {
        get async throws {
            try await URLSession.shared.getNearbyNotable()
        }
    }
}
