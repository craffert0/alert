// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Observation
import Schema
import URLNetwork

@Observable
class LocalsModel {
    var provider: RecentObservationsProvider
    var mainSelection: String?
    var error: eBirdServiceError?
    var showError = false
    var isLoading = false
    private var locationService: LocationService
    private var allProviders: [String: BirdObservationsProvider] = [:]

    var mainSpecies: eBirdRecentObservation? {
        if let mainSelection {
            provider.observations.first { $0.id == mainSelection }
        } else {
            nil
        }
    }

    init(provider: RecentObservationsProvider,
         locationService: LocationService)
    {
        self.provider = provider
        self.locationService = locationService
    }

    func load() async {
        do {
            try await provider.load()
            try await resetProviders()
        } catch {
            self.error = .from(error)
            showError = true
        }
    }

    func refresh() async {
        do {
            try await provider.refresh()
            try await resetProviders()
        } catch {
            self.error = .from(error)
            showError = true
        }
    }

    private func resetProviders() async throws {
        allProviders = [:]
        if let mainSpecies {
            let provider = BirdObservationsProvider(for: mainSpecies.speciesCode,
                                                    locationService: locationService)
            allProviders[mainSpecies.speciesCode] = provider
            try await provider.load()
        }
    }
}

extension LocalsModel: LoadableModel {}

extension LocalsModel {
    var speciesObservations: [eBirdRecentObservation] {
        guard let speciesCode = mainSpecies?.speciesCode else { return [] }
        if let provider = allProviders[speciesCode] {
            return provider.observations
        } else {
            let provider = BirdObservationsProvider(for: speciesCode,
                                                    locationService: locationService)
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

    func refreshSpecies() async {
        guard let speciesCode = mainSpecies?.speciesCode,
              let provider = allProviders[speciesCode]
        else { return }
        do {
            try await provider.refresh()
        } catch {
            self.error = .from(error)
            showError = true
        }
    }
}
