// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct NotableObservationsView: View {
    @State var provider: NotableObservationsProvider
    @State var model: ObservationsProviderModel
    @ObservedObject var preferences = PreferencesModel.global
    @State var now = TimeDataSource<Date>.currentDate
    @State private var observationSort: ObservationSortOption = .byTime

    init(provider: NotableObservationsProvider) {
        self.provider = provider
        model = ObservationsProviderModel(provider: provider)
    }

    var body: some View {
        NavigationStack {
            RangeView(range: provider.loadedRange) {
                Task { @MainActor in
                    await model.load()
                }
            }
            if !model.loading, provider.observations.isEmpty {
                EmptyView(name: "rare")
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
                BirdObservationsView(o)
            } label: {
                Text(o.latestSighting, relativeTo: now)
                Text(o.comName)
                Text("(\(o.locations.total_count))")
            }
        }
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
            let provider = NotableObservationsProvider(
                client: FakeObservationsClient(observations: []),
                checklistDataService: checklistDataService,
                locationService: locationService
            )
            NotableObservationsView(provider: provider)
        }
        Tab("Some", systemImage: "bird.circle") {
            let provider = NotableObservationsProvider(
                client: FakeObservationsClient(observations: .fake),
                checklistDataService: checklistDataService,
                locationService: locationService
            )
            NotableObservationsView(provider: provider)
        }
    }
}
