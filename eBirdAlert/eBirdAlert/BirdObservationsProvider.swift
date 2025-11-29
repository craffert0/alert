// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema

@Observable
class BirdObservationsProvider {
    var observations: [eBirdRecentObservation] = []
    var loadedRange: RangeType?
    private let preferences = PreferencesModel.global
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
            rangeChanged ||
            Date.now.timeIntervalSince(lastLoadTime) > 3600
        {
            try await refresh()
        }
    }

    private var rangeChanged: Bool {
        guard let loadedRange,
              let range = try? preferences.range(for: locationService.location)
        else { return false }
        return loadedRange != range
    }

    func refresh() async throws {
        let range = try preferences.range(for: locationService.location)
        observations = try await URLSession.shared.getBird(in: range,
                                                           for: speciesCode)
        loadedRange = range
    }
}

extension BirdObservationsProvider: ObservationsProviderProtocol {
    var isEmpty: Bool { observations.isEmpty }
}
