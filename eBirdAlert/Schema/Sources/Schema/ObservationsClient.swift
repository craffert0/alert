// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public protocol ObservationsClient {
    // Get all the observations from the server, including duplicates.
    func get(in range: RangeType,
             back daysBack: Int) async throws -> [eBirdObservation]
}

public extension ObservationsClient {
    func observations(in range: RangeType,
                      back daysBack: Int) async throws
        -> [eBirdObservation]
    {
        // remove duplicates
        try await Array(Set(get(in: range, back: daysBack)))
    }
}
