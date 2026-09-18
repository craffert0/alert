// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema

@Observable
class ObservationsProvider<T> {
    var observations: [T] = []
    private let locationService: LocationService
    private let loader: (RangeType, Int) async throws -> [T]
    private let service: eBirdRegionService = FixedRegionService.global
    private var loadedOption: LookupOption?
    private var lastLoadTime: Date?

    init(locationService: LocationService,
         loader: @escaping (RangeType, Int) async throws -> [T])
    {
        self.locationService = locationService
        self.loader = loader
    }

    func load(option: LookupOption) async throws {
        if lastLoadTime == nil ||
            option != loadedOption ||
            observations.isEmpty ||
            Date.now.timeIntervalSince(lastLoadTime!) > 3600
        {
            try await forceLoad(option: option)
            loadedOption = option
        }
    }

    func refresh() async throws {
        guard let loadedOption else { return }
        try await forceLoad(option: loadedOption)
    }

    private func forceLoad(option: LookupOption) async throws {
        observations = try await loader(
            option.range(for: locationService.location, with: service),
            option.daysBack
        )
        lastLoadTime = Date.now
    }
}
