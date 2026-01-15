// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import URLNetwork

public class FakeObservationsClient {
    private let observations: [eBirdObservation]?

    init(observations: [eBirdObservation]? = nil) {
        self.observations = observations
    }
}

extension FakeObservationsClient: ObservationsClient {
    public func get(in _: Schema.RangeType, back _: Int) async throws -> [Schema.eBirdObservation] {
        guard let observations else {
            throw eBirdServiceError.noLocation
        }
        return observations
    }
}
