// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Observation
import Schema

@Observable
class NotableObservationsProvider {
    var observations: [BirdObservations] = []
    private let client: NotableObservationsClient

    init(client: NotableObservationsClient) {
        self.client = client
    }

    func refresh() async throws {
        let latestObservations = try await client.observations
        observations = latestObservations.collate()
    }
}
