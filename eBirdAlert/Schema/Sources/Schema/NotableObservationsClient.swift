// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public struct NotableObservationsClient {
    let service: eBirdService

    public init(service: any eBirdService) {
        self.service = service
    }

    public var observations: [eBirdObservation] {
        get async throws {
            try await service.getNearbyNotable()
        }
    }
}
