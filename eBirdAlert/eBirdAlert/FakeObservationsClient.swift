// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import Schema

public class FakeObservationsClient {
    private let observations: [eBirdObservation]?

    init(observations: [eBirdObservation]? = nil) {
        self.observations = observations
    }
}

extension FakeObservationsClient: ObservationsClient {
    public func get(near _: CLLocation) async throws
        -> [eBirdObservation]
    {
        guard let observations else {
            throw eBirdServiceError.noLocation
        }
        return observations
    }
}
