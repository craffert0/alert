// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import Foundation

public protocol ObservationsClient {
    // Get all the observations from the server, including duplicates.
    func get(near location: CLLocation) async throws -> [eBirdObservation]
}

public extension ObservationsClient {
    func observations(near location: CLLocation) async throws
        -> [eBirdObservation]
    {
        // remove duplicates
        try await Array(Set(get(near: location)))
    }
}
