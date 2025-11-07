// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema

@Observable
class BirdObservationsProvider {
    var observations: [eBirdRecentObservation] = []
    private let speciesCode: String
    private let locationService: LocationService
    private var lastLoadTime: Date?

    init(for speciesCode: String,
         locationService: LocationService)
    {
        self.speciesCode = speciesCode
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
        observations =
            try await URLSession.shared.getBird(
                near: location, for: speciesCode
            )
    }
}

extension BirdObservationsProvider: ObservationsProviderProtocol {
    var isEmpty: Bool { observations.isEmpty }
}
