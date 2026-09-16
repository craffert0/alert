// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema

@Observable
class NotableObservationsProvider {
    var observations: [BirdObservations] { provider.observations }
    private var provider: ObservationsProvider<BirdObservations>

    init(client: ObservationsClient,
         checklistDataService: ChecklistDataService,
         locationService: LocationService,
         remoteNotificationService: RemoteNotificationService? = nil)
    {
        provider = ObservationsProvider(locationService: locationService) { range, daysBack in
            let observations =
                try await client.observations(in: range, back: daysBack).collate()
            for o in observations {
                for l in o.locations {
                    for e in l.observations {
                        await checklistDataService.prepare(obs: e)
                    }
                }
            }
            remoteNotificationService?.register(
                range: range,
                daysBack: daysBack,
                birdsSeen: observations
            )
            return observations
        }
    }

    func load(option: LookupOption) async throws {
        try await provider.load(option: option)
    }

    func refresh() async throws {
        try await provider.refresh()
    }
}

extension NotableObservationsProvider: ObservationsProviderProtocol {
    var isEmpty: Bool { observations.isEmpty }
}
