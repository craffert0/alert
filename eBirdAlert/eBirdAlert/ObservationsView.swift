// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct ObservationsView: View {
    @State var provider: ObservationsProvider
    @State var model: ObservationsProviderModel
    @ObservedObject var preferences = PreferencesModel.global
    @State var now = TimeDataSource<Date>.currentDate

    init(provider: ObservationsProvider) {
        self.provider = provider
        model = ObservationsProviderModel(provider: provider)
    }

    var body: some View {
        NavigationStack {
            if !model.loading, provider.observations.isEmpty {
                EmptyView()
            } else {
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
        List(provider.observations) { o in
            NavigationLink {
                BirdObservationsView(o)
            } label: {
                Text(o.latestSighting, relativeTo: now)
                Text(o.comName)
                Text("(\(o.locations.total_count))")
            }
        }
        .navigationTitle("Rarities")
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.automatic)
        .refreshable {
            await model.refresh()
        }
    }
}

#Preview {
    let checklistDataService = FakeChecklistDataService()
    let locationService = FixedLocationService(latitude: 41, longitude: -74)
    TabView {
        Tab("None", systemImage: "bird.circle.fill") {
            let provider = ObservationsProvider(
                client: FakeObservationsClient(observations: []),
                checklistDataService: checklistDataService,
                locationService: locationService
            )
            ObservationsView(provider: provider)
        }
        Tab("Some", systemImage: "bird.circle") {
            let provider = ObservationsProvider(
                client: FakeObservationsClient(observations: .fake),
                checklistDataService: checklistDataService,
                locationService: locationService
            )
            ObservationsView(provider: provider)
        }
    }
}
