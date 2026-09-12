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

    var mainSpecies: eBirdRecentObservation? {
        if let mainSelection {
            provider.observations.first { $0.id == mainSelection }
        } else {
            nil
        }
    }

    init(provider: RecentObservationsProvider) {
        self.provider = provider
    }

    func load() async {
        do {
            try await provider.load()
        } catch {
            self.error = .from(error)
            showError = true
        }
    }

    func refresh() async {
        do {
            try await provider.refresh()
        } catch {
            self.error = .from(error)
            showError = true
        }
    }
}

extension LocalsModel: LoadableModel {}
