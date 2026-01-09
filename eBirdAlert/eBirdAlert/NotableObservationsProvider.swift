// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema

@Observable
class NotableObservationsProvider {
    var observations: [BirdObservations] { provider.observations }
    var loadedRange: RangeType? { provider.loadedRange }
    private var provider: ObservationsProvider<BirdObservations>

    init(client: ObservationsClient,
         checklistDataService: ChecklistDataService,
         locationService: LocationService)
    {
        provider = ObservationsProvider(locationService: locationService) { range, daysBack in
            let observations =
                try await client.observations(in: range, back: daysBack).collate()
            for o in observations {
                for l in o.locations {
                    for e in l.observations {
                        await checklistDataService.prepare(obs: e)
                    }
                }
            }
            return observations
        }
    }

    func load() async throws {
        try await provider.load()
    }

    func refresh() async throws {
        try await provider.refresh()
    }
}

extension NotableObservationsProvider: ObservationsProviderProtocol {
    var isEmpty: Bool { observations.isEmpty }
}
