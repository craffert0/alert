// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema

@Observable
class RecentObservationsProvider {
    var observations: [eBirdRecentObservation] = []
    var loadedRange: RangeType?
    private let preferences = PreferencesModel.global
    private let client: RecentObservationsClient
    private let checklistDataService: ChecklistDataService
    private let locationService: LocationService
    private var lastLoadTime: Date?

    init(client: RecentObservationsClient,
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
        observations = try await client.get(in: range)
        loadedRange = range
        lastLoadTime = Date.now
    }
}

extension RecentObservationsProvider: ObservationsProviderProtocol {
    var isEmpty: Bool { observations.isEmpty }
}
