// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema

@Observable
class RecentObservationsProvider {
    private var provider: ObservationsProvider<eBirdRecentObservation>

    init(client: RecentObservationsClient,
         checklistDataService: ChecklistDataService,
         locationService: LocationService)
    {
        provider = ObservationsProvider(locationService: locationService) { range, daysBack in
            let observations =
                try await client.get(in: range, back: daysBack)
            for o in observations {
                checklistDataService.prepare(obs: o)
            }
            return observations
        }
    }

    func load(option: LookupOption) async throws -> [eBirdRecentObservation] {
        try await provider.load(option: option)
        return provider.observations
    }

    func refresh() async throws -> [eBirdRecentObservation] {
        try await provider.refresh()
        return provider.observations
    }
}
