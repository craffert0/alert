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
        for o in observations {
            for l in o.locations {
                for e in l.observations {
                    await SwiftDataService.shared.prepare(checklist: e.subId)
                }
            }
        }
    }
}
