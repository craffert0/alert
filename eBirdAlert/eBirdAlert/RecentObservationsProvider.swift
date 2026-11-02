// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema

extension ObservationsProvider<eBirdRecentObservation> {
    convenience init(client: RecentObservationsClient,
                     checklistDataService: ChecklistDataService,
                     locationService: LocationService)
    {
        self.init(locationService: locationService) { range, daysBack in
            let observations =
                try await client.get(in: range, back: daysBack)
            for o in observations {
                checklistDataService.prepare(obs: o)
            }
            return observations
        }
    }
}
