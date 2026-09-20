// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct LocalsView: View {
    @Environment(LocationService.self) var locationService
    @Environment(SwiftDataService.self) var swiftDataService
    @Environment(MergedModel.self) var model
    @ObservedObject var preferences = PreferencesModel.global
    @State var now = TimeDataSource<Date>.currentDate
    @State var mainSelection: String?
    @State var locationSelection: String?

    private var observations: [eBirdRecentObservation] {
        model.localObservations
    }

    private var speciesObservations: [eBirdRecentObservation] {
        guard let mainSpecies else { return [] }
        return model.observationProvider(for: mainSpecies.speciesCode).observations
    }

    var mainSpecies: eBirdRecentObservation? {
        if let mainSelection {
            observations.first { $0.id == mainSelection }
        } else {
            nil
        }
    }

    var selectedLocation: eBirdRecentObservation? {
        if let locationSelection {
            speciesObservations.first { $0.id == locationSelection }
        } else {
            nil
        }
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

extension LocalsView {
    private var mainView: some View {
        MergedMainView(observations: observations,
                       sort: preferences.$localsSort,
                       name: "local",
                       selection: $mainSelection)
        { o in
            HStack {
                Text(o.obsDt, relativeTo: now)
                Text(o.comName)
            }
        }
        .refreshable {
            await model.refreshLocals()
        }
        .navigationTitle("Locals")
    }
}

extension LocalsView {
    @ViewBuilder
    private var contentView: some View {
        if let mainSpecies {
            MergedContentView(mainSpecies) {
                List(speciesObservations,
                     selection: $locationSelection)
                { obs in
                    HStack {
                        Text(obs.obsDt, relativeTo: now)
                        Text(obs.locName)
                    }
                }
                .refreshable {
                    await model.refreshSpecies(
                        speciesCode: mainSpecies.speciesCode
                    )
                }
            }
        }
    }
}

extension LocalsView {
    @ViewBuilder
    private var detailView: some View {
        if let selectedLocation {
            eBirdObservationView(
                selectedLocation,
                in: swiftDataService.load(obs: selectedLocation)
            )
        }
    }
}
