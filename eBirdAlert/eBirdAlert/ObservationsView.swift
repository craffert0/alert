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
                emptyView
            } else {
                listView
            }
        }
        .alert(isPresented: $showError, error: error) {}
        .task {
            await load()
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

    private var emptyView: some View {
        Form {
            Text(emptyText)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.largeTitle)
            Text("Consider expanding your range in your Settings")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.largeTitle)
        }
        .navigationTitle("No Rare Birds")
        .navigationBarTitleDisplayMode(.large)
    }

    private var emptyText: String {
        let daysBack = Int(preferences.daysBack)
        let days = daysBack == 1 ? "day" : "\(daysBack) days"
        let distance = preferences.distValue.formatted(.eBirdFormat)
            + " "
            + preferences.distUnits.rawValue

        return "In the past \(days), there has been no" +
            " rare bird sighting within \(distance)."
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
        while true {
            try await provider.load()
            if !provider.observations.isEmpty ||
                preferences.distValue >= preferences.maxDistance
            {
                return
            }
            preferences.distValue =
                min(2 * preferences.distValue, preferences.maxDistance)
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
