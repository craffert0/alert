// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct BirdObservationsView: View {
    @State var o: BirdObservations
    @State var showEBird: Bool = false
    @State var showPhotos: Bool = false
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

            buttonsView

            List(o.locations) { l in
                NavigationLink {
                    LocationObservationsView(l)
                } label: {
                    Text(l.latestSighting, relativeTo: now)
                    Text(l.locName)
                    Text("(\(l.observations.count))")
                }
            }
            .listStyle(.automatic)
            .navigationTitle(o.comName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var buttonsView: some View {
        HStack {
            Spacer()

            Button("Identify", systemImage: "person.crop.badge.magnifyingglass") {
                showEBird = true
            }.sheet(isPresented: $showEBird) {
                SafariView(speciesCode: o.speciesCode, site: .ebird)
            }

            Spacer()

            Button("Photos", systemImage: "photo.artframe") {
                showPhotos = true
            }.sheet(isPresented: $showPhotos) {
                SafariView(speciesCode: o.speciesCode, site: .macaulay)
            }

            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        BirdObservationsView(BirdObservations(observations: [.fake]))
    }
}
