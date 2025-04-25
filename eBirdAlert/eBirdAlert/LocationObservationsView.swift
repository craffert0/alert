// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema
import SwiftUI

struct LocationObservationsView: View {
    @Environment(SwiftDataService.self) var swiftDataService

    let l: LocationObservations

    init(_ l: LocationObservations) {
        self.l = l
    }

    var body: some View {
        VStack {
            Button(l.locName) {
                l.openMap()
            }
            List {
                let now = Date.now
                ForEach(l.observations) { e in
                    if let comments = swiftDataService
                        .load(obs: e)
                        .observation(for: e.obsId)?
                        .comments
                    {
                        NavigationLink {
                            eBirdObservationView(
                                e, in: swiftDataService.load(obs: e)
                            )
                        } label: {
                            Text(e.obsDt.relative(to: now))
                            Text(comments)
                        }
                    }
                }
            }
        }
    }
}
