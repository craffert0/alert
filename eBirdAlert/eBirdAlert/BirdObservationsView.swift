// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct BirdObservationsView: View {
    let o: BirdObservations
    @State var showSpecies: Bool = false

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

            Button("Details", systemImage: "network") {
                showSpecies = true
            }.sheet(isPresented: $showSpecies) {
                SafariView(species: o)
            }

            List {
                let now = Date.now
                ForEach(o.locations) { l in
                    NavigationLink {
                        LocationObservationsView(l)
                    } label: {
                        Text(l.latestSighting.relative(to: now))
                        Text(l.locName)
                        Text("(\(l.observations.count))")
                    }
                }
            }
            .listStyle(.automatic)
            .navigationTitle(o.comName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
