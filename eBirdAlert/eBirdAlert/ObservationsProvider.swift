// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema
import URLNetwork

@MainActor
class ObservationsProvider<T> {
    private let locationService: LocationService
    private let loader: (RangeType, Int) async throws -> [T]
    private let service: eBirdRegionService = FixedRegionService.global
    private var noObservations = true
    private var loadedOption: LookupOption?
    private var lastLoadTime: Date?

    init(locationService: LocationService,
         loader: @escaping (RangeType, Int) async throws -> [T])
    {
        self.locationService = locationService
        self.loader = loader
    }

    func load(option: LookupOption) async throws -> [T]? {
        guard lastLoadTime == nil ||
            option != loadedOption ||
            noObservations ||
            Date.now.timeIntervalSince(lastLoadTime!) > 3600
        else { return nil }

        let observations = try await forceLoad(option: option)
        loadedOption = option
        lastLoadTime = Date.now
        noObservations = observations.isEmpty
        return observations
    }

    func refresh() async throws -> [T] {
        guard let loadedOption else { throw eBirdServiceError.noLocation }
        let observations = try await forceLoad(option: loadedOption)
        lastLoadTime = Date.now
        noObservations = observations.isEmpty
        return observations
    }

    @concurrent
    private func forceLoad(option: LookupOption) async throws -> [T] {
        try await loader(
            option.range(for: locationService.location, with: service),
            option.daysBack
        )
    }
}
