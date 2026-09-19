// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct LocalsView: View {
    @Environment(LocationService.self) var locationService
    @ObservedObject var preferences = PreferencesModel.global
    @State var now = TimeDataSource<Date>.currentDate
    @State var model: MergedModel
    @State var mainSelection: String?
    @State var locationSelection: String?
    @State var searchText: String = ""

    let swiftDataService: SwiftDataService

    var observations: [eBirdRecentObservation] { model.localObservations }

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

extension LocalsView {
    private var restrictedObservations: [eBirdRecentObservation] {
        observations.restrict(by: searchText)
    }

    private var mainView: some View {
        VStack {
            ObservationPreferencesView(sort: preferences.$localsSort)
            emptyOrListView
                .searchable(text: $searchText)
        }
        .navigationTitle("Locals")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var emptyOrListView: some View {
        if observations.isEmpty {
            EmptyResultsView(name: "local")
        } else {
            mainListView
        }
    }

    private var mainListView: some View {
        GroupedListView(observations: restrictedObservations,
                        sort: preferences.localsSort,
                        model: model,
                        selection: $mainSelection)
        { o in
            HStack {
                Text(o.obsDt, relativeTo: now)
                Text(o.comName)
            }
        }
        .refreshable {
            await model.refresh()
        }
    }
}

extension LocalsView {
    @ViewBuilder
    private var contentView: some View {
        if let mainSpecies {
            VStack {
                Text(mainSpecies.sciName)
                Spacer()

                BirdButtonsView(speciesCode: mainSpecies.speciesCode)

                List(speciesObservations,
                     selection: $locationSelection)
                { obs in
                    HStack {
                        Text(obs.obsDt, relativeTo: now)
                        Text(obs.locName)
                    }
                }
                .refreshable {
                    await refreshSpecies()
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
        if let selectedLocation {
            eBirdObservationView(
                selectedLocation,
                in: swiftDataService.load(obs: selectedLocation)
            )
        }
    }
}

extension LocalsView {
    var speciesObservations: [eBirdRecentObservation] {
        guard let mainSpecies else { return [] }
        return model.speciesObservations(for: mainSpecies.speciesCode)
    }

    func refreshSpecies() async {
        if let mainSpecies {
            await model.refreshSpecies(speciesCode: mainSpecies.speciesCode)
        }
    }
}
