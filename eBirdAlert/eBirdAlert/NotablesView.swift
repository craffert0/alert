// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct NotablesView: View {
    @Environment(NotificationService.self) var notificationService
    @Environment(LocationService.self) var locationService
    @Environment(SwiftDataService.self) var swiftDataService
    @Environment(MergedModel.self) var model
    @ObservedObject var preferences = PreferencesModel.global
    @State var now = TimeDataSource<Date>.currentDate
    @State var mainSelection: String?
    @State var locationSelection: String?

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
    private var mainView: some View {
        MergedMainView(observations: observations,
                       sort: preferences.$notableSort,
                       name: "rare",
                       selection: $mainSelection)
        { o in
            HStack {
                Text(o.latestSighting, relativeTo: now)
                Text(o.comName)
                Text("(\(o.locations.total_count))")
            }
        }
        .refreshable {
            await model.refreshNotables()
        }
        .navigationTitle("Rarities")
    }
}

extension NotablesView {
    @ViewBuilder
    private var contentView: some View {
        if let mainObservations {
            MergedContentView(mainObservations) {
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
