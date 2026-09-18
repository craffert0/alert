// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema

@Observable
class BirdObservationsProvider {
    var observations: [eBirdRecentObservation] { provider.observations }
    private var provider: ObservationsProvider<eBirdRecentObservation>

    init(for speciesCode: String,
         locationService: LocationService)
    {
        provider = ObservationsProvider(locationService: locationService) { range, daysBack in
            try await eBirdServiceGlobal.getBird(in: range,
                                                 back: daysBack,
                                                 for: speciesCode)
        }
    }

    func load(option: LookupOption) async throws {
        try await provider.load(option: option)
    }

    func refresh() async throws {
        try await provider.refresh()
    }
}
