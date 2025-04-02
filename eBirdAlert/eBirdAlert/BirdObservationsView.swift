// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct BirdObservationsView: View {
    let o: BirdObservations

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
            NavigationLink {
                SpeciesDetailView(species: o)
            } label: {
                Label("Details", systemImage: "network")
            }
            List {
                ForEach(o.observations) { e in
                    NavigationLink {
                        eBirdObservationView(e)
                    } label: {
                        Text(e.locName)
                    }
                }
            }
            .listStyle(.automatic)
            .navigationTitle(o.comName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
