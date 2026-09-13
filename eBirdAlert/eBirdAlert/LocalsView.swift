// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct LocalsView: View {
    @Environment(LocationService.self) var locationService
    @ObservedObject var preferences = PreferencesModel.global
    @State var now = TimeDataSource<Date>.currentDate
    @State var model: LocalsModel
    @State var searchText: String = ""

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
                preferencesView
                mainListView
                    .searchable(text: $searchText)
                    .refreshable {
                        await model.refresh()
                    }
            }
            .navigationTitle("Locals")
            .navigationBarTitleDisplayMode(.inline)
        } content: {
            contentView
        } detail: {
            detailView
        }
    }

    private var preferencesView: some View {
        ObservationPreferencesView(model: model,
                                   sort: preferences.$localsSort)
    }
}

extension LocalsView {
    private var restrictedObservations: [eBirdRecentObservation] {
        model.observations.restrict(by: searchText)
    }

    @ViewBuilder
    private var mainListView: some View {
        if let grouped = preferences.localsSort.group(restrictedObservations) {
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
            List(preferences.localsSort.sort(restrictedObservations),
                 selection: $model.mainSelection)
            { o in
                mainEntry(o)
            }
        }
    }

    private func mainEntry(_ o: eBirdRecentObservation) -> some View {
        HStack {
            Text(o.obsDt, relativeTo: now)
            Text(o.comName)
        }
    }
}

extension LocalsView {
    @ViewBuilder
    private var contentView: some View {
        if let mainSpecies = model.mainSpecies {
            VStack {
                Text(mainSpecies.sciName)
                Spacer()

                BirdButtonsView(speciesCode: mainSpecies.speciesCode)

                List(model.speciesObservations,
                     selection: $model.locationSelection)
                { obs in
                    HStack {
                        Text(obs.obsDt, relativeTo: now)
                        Text(obs.locName)
                    }
                }
                .refreshable {
                    await model.refreshSpecies()
                }
            }
            .navigationTitle(mainSpecies.comName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension LocalsView {
    @ViewBuilder
    private var detailView: some View {
        if let checklist = model.selectedChecklist,
           let e = model.selectedLocation
        {
            eBirdObservationView(e, in: checklist)
        }
    }
}
