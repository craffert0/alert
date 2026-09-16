// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct NotablesView: View {
    @Environment(NotificationService.self) private var notificationService
    @Environment(LocationService.self) var locationService
    @Environment(SwiftDataService.self) var swiftDataService
    @ObservedObject var preferences = PreferencesModel.global
    @State var now = TimeDataSource<Date>.currentDate
    @State var model: NotablesModel
    @State var searchText: String = ""
    @State var updater: Bool = false

    var body: some View {
        if locationService.location == nil {
            Text("no location 😢")
        } else {
            ZStack(alignment: .center) {
                splitView
                    .onChange(of: model.mainSelection) {
                        model.locationSelection = nil
                    }
                if model.isLoading {
                    ProgressView()
                }
            }
            .task {
                await model.load()
                try? await notificationService.clearBadgeCount()
            }
            .alert(isPresented: $model.showError, error: model.error) { _ in
                Button("OK") {
                    updater.toggle()
                }
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
        model.observations.restrict(by: searchText)
    }

    private var mainView: some View {
        VStack {
            ObservationPreferencesView(sort: preferences.$notableSort)
                .id(updater)
            mainListView
                .searchable(text: $searchText)
                .onChange(of: preferences.lookupOption) {
                    Task { @MainActor in
                        await model.load()
                    }
                }
                .refreshable {
                    await model.refresh()
                }
        }
        .navigationTitle("Rarities")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var mainListView: some View {
        GroupedListView(observations: restrictedObservations,
                        sort: preferences.notableSort,
                        model: model,
                        selection: $model.mainSelection)
        { o in
            HStack {
                Text(o.latestSighting, relativeTo: now)
                Text(o.comName)
                Text("(\(o.locations.total_count))")
            }
        }
    }
}

extension NotablesView {
    @ViewBuilder
    private var contentView: some View {
        if let mainObservations = model.mainObservations {
            VStack {
                Text(mainObservations.sciName)
                Spacer()

                BirdButtonsView(speciesCode: mainObservations.speciesCode)

                List(mainObservations.locations,
                     selection: $model.locationSelection)
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
        if let locationObservations = model.locationObservations {
            NavigationStack {
                LocationObservationsView(locationObservations)
                    .navigationTitle(locationObservations.comName)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
