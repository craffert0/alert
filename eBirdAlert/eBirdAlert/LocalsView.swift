// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct LocalsView: View {
    @Environment(LocationService.self) var locationService
    @Environment(SwiftDataService.self) var swiftDataService
    @ObservedObject var preferences = PreferencesModel.global

    @State var model: LocalsViewModel
    @State var now = TimeDataSource<Date>.currentDate
    @State var columnVisibility = NavigationSplitViewVisibility.all
    @State var mainSelection: String?
    @State var locationSelection: String?

    private var speciesObservations: [eBirdRecentObservation] {
        guard let mainSpecies else { return [] }
        return model.observationProvider(for: mainSpecies.speciesCode).observations
    }

    var mainSpecies: eBirdRecentObservation? {
        if let mainSelection {
            model.observations.first { $0.id == mainSelection }
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
                GeometryReader { geometry in
                    splitView(size: geometry.size)
                }
                if model.isLoading {
                    ProgressView()
                }
            }
        }
    }

    private func splitView(size: CGSize) -> some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            mainView
        } content: {
            contentView
        } detail: {
            detailView
        }
        .task {
            await model.load()
        }
        .onAppear {
            if mainSpecies == nil {
                columnVisibility = .all
            }
        }
        .onChange(of: preferences.lookupOption) {
            Task { @MainActor in
                await model.load()
                if mainSpecies == nil {
                    mainSelection = nil
                }
            }
        }
        .onChange(of: mainSelection) {
            locationSelection = nil
            if mainSelection == nil {
                columnVisibility = .all
            } else if size.width < size.height {
                columnVisibility = .doubleColumn
            }
        }
        .onChange(of: model.observations) {
            columnVisibility = .all
        }
        .alert(isPresented: $model.showError, error: model.error) { _ in
        } message: { e in
            e.view
        }
    }
}

extension LocalsView {
    private var mainView: some View {
        MergedMainView(observations: model.observations,
                       isLoading: model.isLoading,
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
            await model.refresh()
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
