// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Observation
import Schema
import URLNetwork

@Observable
@MainActor
final class NotablesViewModel {
    private let preferences = PreferencesModel.global
    private let provider: ObservationsProvider<BirdObservations>

    var observations: [BirdObservations] = []
    var isLoading = false
    var showError = false
    var error: eBirdServiceError?

    init(provider: ObservationsProvider<BirdObservations>) {
        self.provider = provider
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            try await tryLoading()
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

    private func tryLoading() async throws {
        var retried = false
        var option = preferences.lookupOption
        guard let newObservations = try await provider.load(option: option) else {
            return
        }
        observations = newObservations
        while observations.isEmpty,
              let expanded = option.expanded
        {
            retried = true
            option = expanded
            guard let newObservations = try await provider.load(option: option) else {
                return
            }
            observations = newObservations
        }

        if retried {
            preferences.lookupOption = option
            if !observations.isEmpty,
               case let .radius(distance, units) = option.range
            {
                throw eBirdServiceError.expandedArea(distance: distance,
                                                     units: units)
            }
        }
    }
}
