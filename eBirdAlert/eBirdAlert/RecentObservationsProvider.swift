// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema

@Observable
class RecentObservationsProvider {
    var observations: [eBirdRecentObservation] { provider.observations }
    var loadedRange: RangeType? { provider.loadedRange }
    private var provider: ObservationsProvider<eBirdRecentObservation>
    private let checklistDataService: ChecklistDataService

    init(client: RecentObservationsClient,
         checklistDataService: ChecklistDataService,
         locationService: LocationService)
    {
        provider = ObservationsProvider(locationService: locationService) { range in
            try await client.get(in: range)
        }
        self.checklistDataService = checklistDataService
    }

    func load() async throws {
        try await provider.load()
    }

    func refresh() async throws {
        try await provider.refresh()
    }
}

extension RecentObservationsProvider: ObservationsProviderProtocol {
    var isEmpty: Bool { observations.isEmpty }
}
