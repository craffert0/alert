// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct NotablesView: View {
    @Environment(NotificationService.self) var notificationService
    @Environment(LocationService.self) var locationService
    @Environment(SwiftDataService.self) var swiftDataService
    @ObservedObject var preferences = PreferencesModel.global
    @State var now = TimeDataSource<Date>.currentDate
    @State var model: MergedModel
    @State var mainSelection: String?
    @State var locationSelection: String?
    @State var searchText: String = ""

    private var observations: [BirdObservations] { model.notableObservations }

    private var mainObservations: BirdObservations? {
        if let mainSelection {
            observations.first { $0.id == mainSelection }
        } else {
            nil
        }
    }

    private var locationObservations: LocationObservations? {
        guard let locationSelection,
              let mainObservations
        else { return nil }
        return mainObservations.locations.first { $0.id == locationSelection }
    }

    var body: some View {
        if locationService.location == nil {
            Text("no location 😢")
        } else {
            ZStack(alignment: .center) {
                splitView
                    .onChange(of: mainSelection) {
                        locationSelection = nil
                    }
                if model.isLoading {
                    ProgressView()
                }
            }
            .task {
                try? await notificationService.clearBadgeCount()
            }
            .alert(isPresented: $model.showError, error: model.error) { _ in
            } message: { e in
                e.view
            }
        }
    }

    private var splitView: some View {
        NavigationSplitView {
            mainView
        } content: {
            contentView
        } detail: {
            detailView
        }
    }
}

extension NotablesView {
    private var restrictedObservations: [BirdObservations] {
        observations.restrict(by: searchText)
    }

    private var mainView: some View {
        VStack {
            ObservationPreferencesView(sort: preferences.$notableSort)
            emptyOrListView
                .searchable(text: $searchText)
        }
        .navigationTitle("Rarities")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var emptyOrListView: some View {
        if observations.isEmpty {
            emptyView
        } else {
            mainListView
        }
    }

    private var emptyView: some View {
        EmptyView(
            name: "rare",
            range: try? preferences.range(for: locationService.location,
                                          with: FixedRegionService.global)
        )
    }

    private var mainListView: some View {
        GroupedListView(observations: restrictedObservations,
                        sort: preferences.notableSort,
                        model: model,
                        selection: $mainSelection)
        { o in
            HStack {
                Text(o.latestSighting, relativeTo: now)
                Text(o.comName)
                Text("(\(o.locations.total_count))")
            }
        }
        .refreshable {
            await model.refresh()
        }
    }
}

extension NotablesView {
    @ViewBuilder
    private var contentView: some View {
        if let mainObservations {
            VStack {
                Text(mainObservations.sciName)
                Spacer()

                BirdButtonsView(speciesCode: mainObservations.speciesCode)

                List(mainObservations.locations,
                     selection: $locationSelection)
                { l in
                    HStack {
                        Text(l.latestSighting, relativeTo: now)
                        Text(l.locName)
                        Text("(\(l.observations.count))")
                    }
                }
            }
            .navigationTitle(mainObservations.comName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension NotablesView {
    @ViewBuilder
    private var detailView: some View {
        if let locationObservations {
            NavigationStack {
                LocationObservationsView(locationObservations)
                    .navigationTitle(locationObservations.comName)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
