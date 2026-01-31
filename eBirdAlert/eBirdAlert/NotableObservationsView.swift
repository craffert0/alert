// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct NotableObservationsView: View {
    @Environment(NotificationService.self) private var notificationService
    @Environment(LocationService.self) var locationService
    @State var provider: NotableObservationsProvider
    @State var model: ObservationsProviderModel
    @ObservedObject var preferences = PreferencesModel.global
    @State var now = TimeDataSource<Date>.currentDate
    @State var searchText: String = ""
    var observationSort: ObservationSortOption { preferences.notableSort }
    var restrictedObservations: [BirdObservations] {
        provider.observations.restrict(by: searchText)
    }

    init(provider: NotableObservationsProvider) {
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
                                           sort: preferences.$notableSort)
                if !model.isLoading, provider.observations.isEmpty {
                    EmptyView(name: "rare", range: provider.loadedRange)
                } else {
                    GroupedListView(observations: restrictedObservations,
                                    sort: preferences.notableSort,
                                    model: model)
                    { o in
                        NavigationLink {
                            BirdObservationsView(o)
                        } label: {
                            Text(o.latestSighting, relativeTo: now)
                            Text(o.comName)
                            Text("(\(o.locations.total_count))")
                        }
                    }
                    .navigationTitle("Rarities")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $searchText)
        .task {
            await model.load()
            try? await notificationService.clearBadgeCount()
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
}

#Preview {
    let checklistDataService = FakeChecklistDataService()
    let locationService: LocationService =
        FixedLocationService(latitude: 41, longitude: -74)
    let noLocationService = LocationService()
    let notificationService = NotificationService()
    TabView {
        Tab("Where", systemImage: "globe.americas") {
            let provider = NotableObservationsProvider(
                client: FakeObservationsClient(observations: []),
                checklistDataService: checklistDataService,
                locationService: locationService
            )
            NotableObservationsView(provider: provider)
                .environment(noLocationService)
                .environment(notificationService)
        }
        Tab("None", systemImage: "bird.circle.fill") {
            let provider = NotableObservationsProvider(
                client: FakeObservationsClient(observations: []),
                checklistDataService: checklistDataService,
                locationService: locationService
            )
            NotableObservationsView(provider: provider)
                .environment(locationService)
                .environment(notificationService)
        }
        Tab("Some", systemImage: "bird.circle") {
            let provider = NotableObservationsProvider(
                client: FakeObservationsClient(observations: .fake),
                checklistDataService: checklistDataService,
                locationService: locationService
            )
            NotableObservationsView(provider: provider)
                .environment(locationService)
                .environment(notificationService)
        }
    }
}
