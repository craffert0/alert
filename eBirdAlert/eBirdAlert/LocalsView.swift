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

    var restrictedObservations: [eBirdRecentObservation] {
        model.provider.observations.restrict(by: searchText)
    }

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
                preferencesView
                mainView
                    .searchable(text: $searchText)
                    .refreshable {
                        await model.refresh()
                    }
            }
        } content: {
            contentView
        } detail: {
            detailView
        }
    }

    @ViewBuilder
    private var mainView: some View {
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

    private var preferencesView: some View {
        ObservationPreferencesView(model: model,
                                   sort: preferences.$localsSort)
    }

    @ViewBuilder
    private var contentView: some View {
        if let mainSpecies = model.mainSpecies {
            VStack {
                Text(mainSpecies.sciName)
                Spacer()

                BirdButtonsView(speciesCode: mainSpecies.speciesCode)

                List(model.speciesObservations) { obs in
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

    @ViewBuilder
    private var detailView: some View {}
}
