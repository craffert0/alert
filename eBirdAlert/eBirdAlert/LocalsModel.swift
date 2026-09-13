// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Observation
import Schema
import URLNetwork

@Observable
class LocalsModel {
    var mainSelection: String?
    var locationSelection: String?
    var error: eBirdServiceError?
    var showError = false
    var isLoading = false
    private let provider: RecentObservationsProvider
    private let locationService: LocationService
    private let swiftDataService: SwiftDataService
    private var allProviders: [String: BirdObservationsProvider] = [:]

    var observations: [eBirdRecentObservation] { provider.observations }

    var mainSpecies: eBirdRecentObservation? {
        if let mainSelection {
            provider.observations.first { $0.id == mainSelection }
        } else {
            nil
        }
    }

    var selectedLocation: eBirdRecentObservation? {
        if let locationSelection {
            speciesObservations.first { $0.id == locationSelection }
        } else {
            nil
        }
    }

    @MainActor
    var selectedChecklist: Checklist? {
        guard let selectedLocation else { return nil }
        return swiftDataService.load(obs: selectedLocation)
    }

    init(provider: RecentObservationsProvider,
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
            try await provider.load()
            try await resetProviders()
        } catch {
            self.error = .from(error)
            showError = true
        }
        isLoading = false
    }

    func refresh() async {
        isLoading = true
        do {
            try await provider.refresh()
            try await resetProviders()
        } catch {
            self.error = .from(error)
            showError = true
        }
        isLoading = false
    }

    private func resetProviders() async throws {
        allProviders = [:]
        if let mainSpecies {
            let provider = BirdObservationsProvider(for: mainSpecies.speciesCode,
                                                    locationService: locationService)
            try await provider.load()
            allProviders[mainSpecies.speciesCode] = provider
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
