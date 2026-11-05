// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Observation
import Schema
import URLNetwork

@Observable
@MainActor
final class LocalsViewModel {
    private let preferences = PreferencesModel.global
    private let locationService: LocationService
    private let provider: ObservationsProvider<eBirdRecentObservation>

    var observations: [eBirdRecentObservation] = []
    var isLoading = false
    var showError = false
    var error: eBirdServiceError?
    var allProviders: [String: BirdObservationsProvider] = [:]

    init(locationService: LocationService,
         provider: ObservationsProvider<eBirdRecentObservation>)
    {
        self.locationService = locationService
        self.provider = provider
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            if let newObservations = try await provider.load(option: preferences.lookupOption) {
                observations = newObservations
                allProviders = [:]
            }
        } catch {
            self.error = .from(error)
            showError = true
        }
    }

    func refresh() async {
        do {
            observations = try await provider.refresh()
        } catch {
            self.error = .from(error)
            showError = true
        }
    }

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
