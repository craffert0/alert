// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct RecentObservationsView: View {
    @Environment(LocationService.self) var locationService
    @State var provider: RecentObservationsProvider
    @State var model: ObservationsProviderModel
    @State var now = TimeDataSource<Date>.currentDate
    @State private var observationSort: ObservationSortOption = .byName

    init(provider: RecentObservationsProvider) {
        self.provider = provider
        model = ObservationsProviderModel(provider: provider)
    }

    var body: some View {
        if locationService.location == nil {
            Text("no location 😢")
        } else {
            mainView
        }
    }

    private var mainView: some View {
        NavigationStack {
            RangeView()
            if !model.loading, provider.observations.isEmpty {
                EmptyView(name: "local")
            } else {
                SortPickerView(observationSort: $observationSort)
                listView
            }
        }
        .task {
            await model.load()
        }
        .alert(isPresented: $model.showError, error: model.error) { _ in
        } message: { e in
            if case let .expandedArea(distance, units) = e {
                Text("eBird could not find birds in the original range," +
                    " so we expanded the range to " +
                    distance.formatted(.eBirdFormat) + " " +
                    units.rawValue + " in order to find some.")
            }
        }
    }

    private var listView: some View {
        List(observationSort.sort(provider.observations)) { o in
            NavigationLink {
                RecentBirdView(o: o,
                               provider: BirdObservationsProvider(
                                   for: o.speciesCode,
                                   locationService: locationService
                               ))
            } label: {
                Text(o.obsDt, relativeTo: now)
                Text(o.comName)
            }
        }
        .listStyle(.automatic)
        .refreshable {
            await model.refresh()
        }
    }
}

// #Preview {
//     VStack {
//         RecentObservationsView()
//     }
// }
