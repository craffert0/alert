// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct ObservationsView: View {
    @State var provider: ObservationsProvider
    @ObservedObject var preferences = PreferencesModel.global
    @State private var error: eBirdServiceError?
    @State private var showError = false
    @State var now = TimeDataSource<Date>.currentDate
    @State var loading = false

    init(provider: ObservationsProvider) {
        self.provider = provider
    }

    var body: some View {
        NavigationStack {
            if !loading, provider.observations.isEmpty {
                EmptyView()
            } else {
                listView
            }
        }
        .task {
            await load()
        }
        .alert(isPresented: $showError, error: error) { _ in
        } message: { e in
            if case let .expandedArea(distance, units) = e {
                Text("eBird could not find birds in the original range," +
                    " so we expanded the range to " +
                    distance.formatted(.eBirdFormat) + " " +
                    units.rawValue + " in order to find some.")
            }
        }
    }

    private var listView: some View {
        List(provider.observations) { o in
            NavigationLink {
                BirdObservationsView(o)
            } label: {
                Text(o.latestSighting, relativeTo: now)
                Text(o.comName)
                Text("(\(o.locations.total_count))")
            }
        }
        .navigationTitle("Rarities")
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.automatic)
        .refreshable {
            await refresh()
        }
    }
}

extension ObservationsView {
    func load() async {
        loading = true
        do {
            try await tryLoading()
        } catch {
            self.error = eBirdServiceError.from(error)
            showError = true
        }
        loading = false
    }

    private func tryLoading() async throws {
        var retried = false
        try await provider.load()
        while provider.observations.isEmpty,
              preferences.distValue < preferences.maxDistance
        {
            retried = true
            preferences.distValue =
                min(2 * preferences.distValue, preferences.maxDistance)
            try await provider.load()
        }

        if !provider.observations.isEmpty, retried {
            throw eBirdServiceError.expandedArea(
                distance: preferences.distValue,
                units: preferences.distUnits
            )
        }
    }

    func refresh() async {
        loading = true
        do {
            try await provider.refresh()
        } catch {
            self.error = eBirdServiceError.from(error)
            showError = true
        }
        loading = false
    }
}

#Preview {
    let checklistDataService = FakeChecklistDataService()
    let locationService = FixedLocationService(latitude: 41, longitude: -74)
    TabView {
        Tab("None", systemImage: "bird.circle.fill") {
            let provider = ObservationsProvider(
                client: FakeObservationsClient(observations: []),
                checklistDataService: checklistDataService,
                locationService: locationService
            )
            ObservationsView(provider: provider)
        }
        Tab("Some", systemImage: "bird.circle") {
            let provider = ObservationsProvider(
                client: FakeObservationsClient(observations: .fake),
                checklistDataService: checklistDataService,
                locationService: locationService
            )
            ObservationsView(provider: provider)
        }
    }
}
