// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema
import SwiftUI

struct LocationObservationsView: View {
    let l: LocationObservations

    init(_ l: LocationObservations) {
        self.l = l
    }

    var body: some View {
        VStack {
            Button(l.locName) {
                l.appleMapItem.openInMaps()
                // UIApplication.shared.open(l.googleMapURL)
            }
            List {
                let now = Date.now
                ForEach(l.observations) { e in
                    NavigationLink {
                        eBirdObservationView(e)
                    } label: {
                        Text(e.obsDt.distance(to: now).english)
                        Text(e.userDisplayName)
                    }
                }
            }
        }
    }
}
