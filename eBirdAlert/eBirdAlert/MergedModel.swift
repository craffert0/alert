// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Observation
import Schema
import URLNetwork

@Observable
class MergedModel {
    private let preferences = PreferencesModel.global
    private let locationService: LocationService
    private let swiftDataService: SwiftDataService

    private let notableProvider: NotableObservationsProvider
    private let recentProvider: RecentObservationsProvider

    var allProviders: [String: BirdObservationsProvider] = [:]
    var error: eBirdServiceError?
    var showError = false
    var isLoading = false

    var notableObservations: [BirdObservations] {
        notableProvider.observations
    }

    var localObservations: [eBirdRecentObservation] {
        recentProvider.observations
    }

    init(locationService: LocationService,
         swiftDataService: SwiftDataService,
         notableProvider: NotableObservationsProvider,
         recentProvider: RecentObservationsProvider)
    {
        self.locationService = locationService
        self.swiftDataService = swiftDataService
        self.notableProvider = notableProvider
        self.recentProvider = recentProvider
    }

    func load() async {
        isLoading = true
        do {
            try await tryLoading()
            try await recentProvider.load()
            allProviders = [:]
        } catch {
            self.error = .from(error)
            showError = true
        }
        isLoading = false
    }

    func refresh() async {
        isLoading = true
        do {
            try await notableProvider.refresh()
            try await recentProvider.refresh()
        } catch {
            self.error = .from(error)
            showError = true
        }
        isLoading = false
    }

    private func tryLoading() async throws {
        var retried = false
        try await notableProvider.load()
        while notableProvider.isEmpty,
              preferences.rangeOption == .radius,
              preferences.distValue < .maxNotableDistance
        {
            retried = true
            preferences.distValue =
                min(2 * preferences.distValue, .maxNotableDistance)
            try await notableProvider.load()
        }

        if !notableProvider.isEmpty, retried {
            throw eBirdServiceError.expandedArea(
                distance: preferences.distValue,
                units: preferences.distUnits
            )
        }
    }
}

extension MergedModel {
    func speciesObservations(for speciesCode: String)
        -> [eBirdRecentObservation]
    {
        if let provider = allProviders[speciesCode] {
            return provider.observations
        } else {
            let provider = BirdObservationsProvider(
                for: speciesCode,
                locationService: locationService
            )
            allProviders[speciesCode] = provider
            Task {
                do {
                    try await provider.load()
                } catch {
                    Task { @MainActor in
                        self.error = .from(error)
                        showError = true
                    }
                }
            }
            return provider.observations
        }
    }

    func refreshSpecies(speciesCode: String) async {
        guard let provider = allProviders[speciesCode] else { return }
        do {
            try await provider.refresh()
        } catch {
            self.error = .from(error)
            showError = true
        }
    }
}

extension MergedModel: LoadableModel {}
