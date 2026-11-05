// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct NotablesView: View {
    @Environment(NotificationService.self) var notificationService
    @Environment(LocationService.self) var locationService
    @Environment(SwiftDataService.self) var swiftDataService
    @ObservedObject var preferences = PreferencesModel.global

    @State var model: NotablesViewModel
    @State var now = TimeDataSource<Date>.currentDate
    @State var columnVisibility = NavigationSplitViewVisibility.all
    @State var mainSelection: String?
    @State var locationSelection: String?

    private var mainObservations: BirdObservations? {
        if let mainSelection {
            model.observations.first { $0.id == mainSelection }
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
                GeometryReader { geometry in
                    splitView(size: geometry.size)
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
            if mainSelection == nil {
                columnVisibility = .all
            }
        }
        .onChange(of: preferences.lookupOption) {
            Task { @MainActor in
                await model.load()
                if mainObservations == nil {
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

extension NotablesView {
    private var mainView: some View {
        MergedMainView(observations: model.observations,
                       isLoading: model.isLoading,
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
            await model.refresh()
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
