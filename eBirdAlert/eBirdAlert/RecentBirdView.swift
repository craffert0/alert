// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct RecentBirdView: View {
    let o: eBirdRecentObservation
    @State var provider: BirdObservationsProvider
    @State var model: ObservationsProviderModel
    @State var now = TimeDataSource<Date>.currentDate

    init(o: eBirdRecentObservation,
         provider: BirdObservationsProvider)
    {
        self.o = o
        self.provider = provider
        model = ObservationsProviderModel(provider: provider)
    }

    var body: some View {
        VStack {
            Text(o.sciName)
            Spacer()

            BirdButtonsView(speciesCode: o.speciesCode)

            listView
        }
        .navigationTitle(o.comName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var listView: some View {
        List(provider.observations) { obs in
            HStack {
                Text(obs.obsDt, relativeTo: now)
                Text(obs.locName)
            }
        }
        .task {
            await model.load()
        }
        .refreshable {
            await model.refresh()
        }
    }
}

// #Preview {
//     VStack {
//         RecentBirdView(o: .fake)
//     }
// }
