// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema

extension ObservationsProvider<BirdObservations> {
    convenience init(client: ObservationsClient,
                     checklistDataService: ChecklistDataService,
                     locationService: LocationService,
                     remoteNotificationService: RemoteNotificationService)
    {
        self.init(locationService: locationService) { range, daysBack in
            let observations =
                try await client.observations(in: range, back: daysBack).collate()
            for o in observations {
                for l in o.locations {
                    for e in l.observations {
                        checklistDataService.prepare(obs: e)
                    }
                }
            }
            remoteNotificationService.register(
                range: range,
                daysBack: daysBack,
                birdsSeen: observations
            )
            return observations
        }
    }
}
