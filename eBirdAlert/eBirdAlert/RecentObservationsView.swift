// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct RecentObservationsView: View {
    @Environment(LocationService.self) var locationService
    @State var provider: RecentObservationsProvider
    @State var model: ObservationsProviderModel
    @ObservedObject var preferences = PreferencesModel.global
    @State var now = TimeDataSource<Date>.currentDate
    @State var searchText: String = ""
    var observationSort: ObservationSortOption { preferences.localsSort }
    var restrictedObservations: [eBirdRecentObservation] {
        provider.observations.restrict(by: searchText)
    }

    init(provider: RecentObservationsProvider) {
        self.provider = provider
        model = ObservationsProviderModel(provider: provider)
    }

    var body: some View {
        if locationService.location == nil {
            Text("no location 😢")
        } else {
            ZStack(alignment: .center) {
                mainView
                if model.isLoading {
                    ProgressView()
                }
            }
        }
    }

    private var mainView: some View {
        NavigationStack {
            VStack {
                ObservationPreferencesView(model: model,
                                           sort: preferences.$localsSort)
                if !model.isLoading, provider.observations.isEmpty {
                    EmptyView(name: "local", range: provider.loadedRange)
                } else {
                    GroupedListView(observations: restrictedObservations,
                                    sort: preferences.localsSort,
                                    model: model)
                    { o in
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
                    .navigationTitle("Locals")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $searchText)
        .task {
            await model.load()
        }
        .alert(isPresented: $model.showError, error: model.error) { _ in
        } message: { e in
            e.view
        }
    }
}

// #Preview {
//     VStack {
//         RecentObservationsView()
//     }
// }
