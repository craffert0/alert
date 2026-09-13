// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct NotablesView: View {
    @Environment(LocationService.self) var locationService
    @Environment(SwiftDataService.self) var swiftDataService
    @ObservedObject var preferences = PreferencesModel.global
    @State var now = TimeDataSource<Date>.currentDate
    @State var model: NotablesModel
    @State var searchText: String = ""

    var body: some View {
        if locationService.location == nil {
            Text("no location 😢")
        } else {
            ZStack(alignment: .center) {
                splitView
                if model.isLoading {
                    ProgressView()
                }
            }
            .task {
                await model.load()
            }
            .alert(isPresented: $model.showError, error: model.error) { _ in
            } message: { e in
                e.view
            }
        }
    }

    private var splitView: some View {
        NavigationSplitView {
            VStack {
                ObservationPreferencesView(model: model,
                                           sort: preferences.$notableSort)
                mainListView
                    .searchable(text: $searchText)
                    .refreshable {
                        await model.refresh()
                    }
            }
            .navigationTitle("Rarities")
            .navigationBarTitleDisplayMode(.inline)
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

    @ViewBuilder
    private var mainListView: some View {
        if let grouped = preferences.notableSort.group(restrictedObservations) {
            List(selection: $model.mainSelection) {
                ForEach(grouped, id: \.0) { pair in
                    Section(pair.0.comName) {
                        ForEach(pair.1) { o in
                            mainEntry(o)
                        }
                    }
                }
            }
        } else {
            List(preferences.notableSort.sort(restrictedObservations),
                 selection: $model.mainSelection)
            { o in
                mainEntry(o)
            }
        }
    }

    private func mainEntry(_ o: BirdObservations) -> some View {
        HStack {
            Text(o.latestSighting, relativeTo: now)
            Text(o.comName)
            Text("(\(o.locations.total_count))")
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
            VStack {
                LocationButton(location: locationObservations)
                List(locationObservations.observations) { e in
                    let c = swiftDataService.load(obs: e)
                    if let observation = c.observation(for: e.speciesCode),
                       let comments = observation.comments
                    {
                        HStack {
                            Text(e.obsDt, relativeTo: now)
                            Text(comments)
                            if observation.hasMedia {
                                Text("📸")
                            }
                        }
                    }
                }
            }
            .navigationTitle(model.mainObservations!.comName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
