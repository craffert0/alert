// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Observation

@Observable
class ObservationsProviderModel {
    var provider: ObservationsProviderProtocol
    var preferences = PreferencesModel.global
    var error: eBirdServiceError?
    var showError = false
    var loading = false

    init(provider: ObservationsProviderProtocol) {
        self.provider = provider
    }

    func load() async {
        loading = true
        do {
            try await tryLoading()
        } catch {
            self.error = eBirdServiceError.from(error)
            showError = true
        }
        loading = false
    }

    private func tryLoading() async throws {
        var retried = false
        try await provider.load()
        while provider.isEmpty,
              preferences.distValue < preferences.maxDistance
        {
            retried = true
            preferences.distValue =
                min(2 * preferences.distValue, preferences.maxDistance)
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
        loading = true
        do {
            try await provider.refresh()
        } catch {
            self.error = eBirdServiceError.from(error)
            showError = true
        }
        loading = false
    }
}
