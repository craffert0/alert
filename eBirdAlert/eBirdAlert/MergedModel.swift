// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Observation
import Schema
import URLNetwork

@Observable
@MainActor
class MergedModel {
    private let preferences = PreferencesModel.global
    private let locationService: LocationService

    private let notableProvider: ObservationsProvider<BirdObservations>
    private let recentProvider: ObservationsProvider<eBirdRecentObservation>

    var allProviders: [String: BirdObservationsProvider] = [:]
    var error: eBirdServiceError?
    var showError = false

    var isLoadingNotables = false
    var isLoadingLocals = false

    var isLoading: Bool { isLoadingNotables || isLoadingLocals }

    var notableObservations: [BirdObservations] = []
    var localObservations: [eBirdRecentObservation] = []

    init(locationService: LocationService,
         notableProvider: ObservationsProvider<BirdObservations>,
         recentProvider: ObservationsProvider<eBirdRecentObservation>)
    {
        self.locationService = locationService
        self.notableProvider = notableProvider
        self.recentProvider = recentProvider
    }

    func loadNotables() async {
        guard !isLoadingNotables else { return }
        isLoadingNotables = true
        defer {
            isLoadingNotables = false
        }
        do {
            try await tryLoadingNotables()
        } catch {
            self.error = .from(error)
            showError = true
        }
    }

    func loadLocals() async {
        guard !isLoadingLocals else { return }
        isLoadingLocals = true
        defer {
            isLoadingLocals = false
        }
        do {
            localObservations =
                try await recentProvider.load(option: preferences.lookupOption)
            allProviders = [:]
        } catch {
            self.error = .from(error)
            showError = true
        }
    }

    func refreshNotables() async {
        do {
            notableObservations = try await notableProvider.refresh()
        } catch {
            self.error = .from(error)
            showError = true
        }
    }

    func refreshLocals() async {
        do {
            localObservations = try await recentProvider.refresh()
        } catch {
            self.error = .from(error)
            showError = true
        }
    }

    private func tryLoadingNotables() async throws {
        var retried = false
        var option = preferences.lookupOption
        notableObservations = try await notableProvider.load(option: option)
        while notableObservations.isEmpty,
              let expanded = option.expanded
        {
            retried = true
            option = expanded
            notableObservations = try await notableProvider.load(option: option)
        }

        if retried {
            Task { @MainActor in
                preferences.lookupOption = option
            }
            if !notableObservations.isEmpty,
               case let .radius(distance, units) = option.range
            {
                throw eBirdServiceError.expandedArea(distance: distance,
                                                     units: units)
            }
        }
    }
}

extension MergedModel {
    func observationProvider(for speciesCode: String)
        -> BirdObservationsProvider
    {
        if let provider = allProviders[speciesCode] {
            return provider
        } else {
            let provider = BirdObservationsProvider(
                for: speciesCode,
                locationService: locationService
            )
            allProviders[speciesCode] = provider
            Task { @MainActor in
                do {
                    try await provider.load(option: preferences.lookupOption)
                } catch {
                    self.error = .from(error)
                    showError = true
                }
            }
            return provider
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
