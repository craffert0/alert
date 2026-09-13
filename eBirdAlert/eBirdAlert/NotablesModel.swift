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

    var observations: [BirdObservations] { provider.observations }

    var mainObservations: BirdObservations? {
        if let mainSelection {
            provider.observations.first { $0.id == mainSelection }
        } else {
            nil
        }
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
        // TODO:
    }
}

extension NotablesModel: LoadableModel {}
