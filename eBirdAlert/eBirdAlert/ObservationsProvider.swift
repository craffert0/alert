// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema

@Observable
class ObservationsProvider {
    var observations: [BirdObservations] = []
    var loadedRange: RangeType?
    private let preferences = PreferencesModel.global
    private let client: ObservationsClient
    private let locationService: LocationService
    private let checklistDataService: ChecklistDataService
    private var lastLoadTime: Date?

    init(client: ObservationsClient,
         checklistDataService: ChecklistDataService,
         locationService: LocationService)
    {
        self.client = client
        self.checklistDataService = checklistDataService
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
        let range = try preferences.range(for: locationService.location)
        observations = try await client.observations(in: range).collate()
        for o in observations {
            for l in o.locations {
                for e in l.observations {
                    await checklistDataService.prepare(obs: e)
                }
            }
        }
        loadedRange = range
        lastLoadTime = Date.now
    }
}

extension ObservationsProvider: ObservationsProviderProtocol {
    var isEmpty: Bool { observations.isEmpty }
}
