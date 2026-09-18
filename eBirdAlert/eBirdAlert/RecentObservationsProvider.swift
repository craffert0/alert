// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema

@Observable
class RecentObservationsProvider {
    var observations: [eBirdRecentObservation] { provider.observations }
    private var provider: ObservationsProvider<eBirdRecentObservation>

    init(client: RecentObservationsClient,
         checklistDataService: ChecklistDataService,
         locationService: LocationService)
    {
        provider = ObservationsProvider(locationService: locationService) { range, daysBack in
            let observations =
                try await client.get(in: range, back: daysBack)
            for o in observations {
                await checklistDataService.prepare(obs: o)
            }
            return observations
        }
    }

    func load(option: LookupOption) async throws {
        try await provider.load(option: option)
    }

    func refresh() async throws {
        try await provider.refresh()
    }
}
