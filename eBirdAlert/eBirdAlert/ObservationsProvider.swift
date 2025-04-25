// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema

@Observable
class ObservationsProvider {
    var observations: [BirdObservations] = []
    private let client: ObservationsClient
    private let locationService: LocationService
    private let swiftDataService: SwiftDataService
    private var lastLoadTime: Date?

    init(client: ObservationsClient,
         swiftDataService: SwiftDataService,
         locationService: LocationService)
    {
        self.client = client
        self.swiftDataService = swiftDataService
        self.locationService = locationService
    }

    func load() async throws {
        if Date.now.timeIntervalSince(lastLoadTime ?? Date.distantPast)
            > 3600
        {
            try await refresh()
        }
    }

    func refresh() async throws {
        guard let location = locationService.location else {
            throw eBirdServiceError.noLocation
        }
        observations = try await client.observations(near: location).collate()
        for o in observations {
            for l in o.locations {
                for e in l.observations {
                    await swiftDataService.prepare(obs: e)
                }
            }
        }
        lastLoadTime = Date.now
    }
}
