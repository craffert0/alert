// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema

@Observable
class RecentObservationsProvider {
    var observations: [eBirdRecentObservation] = []
    private let client: RecentObservationsClient
    private let locationService: LocationService
    private var lastLoadTime: Date?

    init(client: RecentObservationsClient,
         locationService: LocationService)
    {
        self.client = client
        self.locationService = locationService
    }

    func load() async throws {
        let lastLoadTime = lastLoadTime ?? Date.distantPast
        if observations.isEmpty ||
            Date.now.timeIntervalSince(lastLoadTime) > 3600
        {
            try await refresh()
        }
    }

    func refresh() async throws {
        guard let location = locationService.location else {
            throw eBirdServiceError.noLocation
        }
        observations = try await client.get(near: location)
        // for o in observations {
        //     for l in o.locations {
        //         for e in l.observations {
        //             await checklistDataService.prepare(obs: e)
        //         }
        //     }
        // }
        lastLoadTime = Date.now
    }
}
