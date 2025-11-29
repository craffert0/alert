// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import Foundation
import Observation
import Schema

@Observable
class ObservationsProvider<T>: ObservationsProviderProtocol {
    var observations: [T] = []
    var loadedRange: RangeType?
    private let locationService: LocationService
    private let loader: (RangeType) async throws -> [T]
    private let preferences = PreferencesModel.global
    private var lastLoadTime: Date?

    init(locationService: LocationService,
         loader: @escaping (RangeType) async throws -> [T])
    {
        self.locationService = locationService
        self.loader = loader
    }

    var isEmpty: Bool { observations.isEmpty }

    func load() async throws {
        let location = locationService.location
        let range = try? preferences.range(for: location)
        if loadedRange == nil ||
            lastLoadTime == nil ||
            observations.isEmpty ||
            range != loadedRange! ||
            Date.now.timeIntervalSince(lastLoadTime!) > 3600
        {
            try await forceLoad(in: range ?? preferences.range(for: location))
        }
    }

    func refresh() async throws {
        let location = locationService.location
        try await forceLoad(in: preferences.range(for: location))
    }

    private func forceLoad(in range: RangeType) async throws {
        observations = try await loader(range)
        loadedRange = range
        lastLoadTime = Date.now
    }
}
