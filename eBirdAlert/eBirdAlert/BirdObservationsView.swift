// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct BirdObservationsView: View {
    @State var o: BirdObservations
    @State var now = TimeDataSource<Date>.currentDate

    init(_ o: BirdObservations) {
        self.o = o
    }

    var body: some View {
        // 1. Bird name on top
        // 2. Short description of bird (if anything)
        // 3. Navigable list of the observations
        // 4. Map?
        VStack {
            Text(o.sciName)
            Spacer()

            BirdButtonsView(speciesCode: o.speciesCode)

            observationsView
        }
        .navigationTitle(o.comName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var observationsView: some View {
        List(o.locations) { l in
            NavigationLink {
                LocationObservationsView(l)
                    .navigationTitle(o.comName)
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                Text(l.latestSighting, relativeTo: now)
                Text(l.locName)
                Text("(\(l.observations.count))")
            }
        }
        .listStyle(.automatic)
    }
}

#Preview {
    NavigationStack {
        BirdObservationsView(BirdObservations(observations: [.fake]))
    }
}
