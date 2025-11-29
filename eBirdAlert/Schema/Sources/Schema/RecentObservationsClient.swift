// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public class RecentObservationsClient {
    let service: eBirdService

    public init(service: any eBirdService) {
        self.service = service
    }

    public func get(in range: RangeType) async throws
        -> [eBirdRecentObservation]
    {
        try await service.getAll(in: range)
    }
}
