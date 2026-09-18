// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Observation
import Schema
import URLNetwork

@Observable
class MergedModel {
    private let preferences = PreferencesModel.global
    private let locationService: LocationService

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
         notableProvider: NotableObservationsProvider,
         recentProvider: RecentObservationsProvider)
    {
        self.locationService = locationService
        self.notableProvider = notableProvider
        self.recentProvider = recentProvider
    }

    func load() async {
        isLoading = true
        do {
            try await recentProvider.load(option: tryLoading())
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

    private func tryLoading() async throws -> LookupOption {
        var retried = false
        var option = preferences.lookupOption
        try await notableProvider.load(option: option)
        while notableProvider.isEmpty,
              let expanded = option.expanded
        {
            retried = true
            option = expanded
            try await notableProvider.load(option: option)
        }

        if retried {
            Task { @MainActor in
                preferences.lookupOption = option
            }
            if !notableProvider.isEmpty,
               case let .radius(distance, units) = option.range
            {
                throw eBirdServiceError.expandedArea(distance: distance,
                                                     units: units)
            }
        }

        return option
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
                    try await provider.load(option: preferences.lookupOption)
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

extension MergedModel: RefreshableModel {}
