// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema
import SwiftUI

struct LocationObservationsView: View {
    @Environment(SwiftDataService.self) var swiftDataService
    @State var now = TimeDataSource<Date>.currentDate

    @State var l: LocationObservations

    init(_ l: LocationObservations) {
        self.l = l
    }

    var body: some View {
        VStack {
            Button(l.locName) {
                l.openMap()
            }
            List(l.observations) { e in
                let c = swiftDataService.load(obs: e)
                if let comments = c.observation(for: e.obsId)?.comments {
                    NavigationLink {
                        eBirdObservationView(e, in: c)
                    } label: {
                        Text(e.obsDt, relativeTo: now)
                        Text(comments)
                    }
                }
            }
        }
    }
}
