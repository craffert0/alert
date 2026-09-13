// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Observation
import Schema
import URLNetwork

@Observable
class NotablesModel {
    var mainSelection: String?
    var locationSelection: String?
    var error: eBirdServiceError?
    var showError = false
    var isLoading = false
    private let provider: NotableObservationsProvider
    private let locationService: LocationService
    private let swiftDataService: SwiftDataService
    private let preferences = PreferencesModel.global

    var observations: [BirdObservations] { provider.observations }

    var mainObservations: BirdObservations? {
        if let mainSelection {
            provider.observations.first { $0.id == mainSelection }
        } else {
            nil
        }
    }

    var locationObservations: LocationObservations? {
        guard let locationSelection,
              let mainObservations
        else { return nil }
        return mainObservations.locations.first { $0.id == locationSelection }
    }

    init(provider: NotableObservationsProvider,
         locationService: LocationService,
         swiftDataService: SwiftDataService)
    {
        self.provider = provider
        self.locationService = locationService
        self.swiftDataService = swiftDataService
    }

    func load() async {
        isLoading = true
        do {
            try await tryLoading()
        } catch {
            self.error = .from(error)
            showError = true
        }
        isLoading = false
    }

    private func tryLoading() async throws {
        var retried = false
        try await provider.load()
        while provider.isEmpty,
              preferences.rangeOption == .radius,
              preferences.distValue < .maxNotableDistance
        {
            retried = true
            preferences.distValue =
                min(2 * preferences.distValue, .maxNotableDistance)
            try await provider.load()
        }

        if !provider.isEmpty, retried {
            throw eBirdServiceError.expandedArea(
                distance: preferences.distValue,
                units: preferences.distUnits
            )
        }
    }

    func refresh() async {
        isLoading = true
        do {
            try await provider.refresh()
        } catch {
            self.error = .from(error)
            showError = true
        }
        isLoading = false
    }
}

extension NotablesModel: LoadableModel {}
