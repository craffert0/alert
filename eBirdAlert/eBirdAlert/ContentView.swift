// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftData
import SwiftUI

struct ContentView: View {
    @ObservedObject var preferences = PreferencesModel.global
    @Environment(\.eBirdNotable) var notableProvider: NotableObservationsProvider?
    @Environment(\.eBirdAll) var recentObservationsProvider: RecentObservationsProvider?

    var body: some View {
        TabView {
            Tab("Rarities", systemImage: "environments.circle") {
                MainView(provider: notableProvider!)
            }

            Tab("Locals", systemImage: "bird.circle") {
                RecentObservationsView(provider: recentObservationsProvider!)
            }

            Tab("Region", systemImage: "map.circle.fill") {
                NavigationStack {
                    DebugRegionView(service: URLSession.cached)
                }
            }

            Tab("Census", systemImage: "map.circle.fill") {
                NavigationStack {
                    CensusView(service: URLSession.shared)
                }
            }

            if preferences.debugMode {
                Tab("Debug", systemImage: "ladybug.circle.fill") {
                    DebugView()
                }
            }

            Tab("Settings", systemImage: "gearshape") {
                PreferencesView()
            }
        }
    }
}

#Preview {
    let locationService: LocationService =
        FixedLocationService(latitude: 41, longitude: -74)
    let client = FakeObservationsClient(observations: .fake)
    let provider =
        NotableObservationsProvider(client: client,
                                    checklistDataService: FakeChecklistDataService(),
                                    locationService: locationService)
    ContentView()
        .modelContainer(for: Checklist.self, inMemory: true)
        .environment(locationService)
        .environment(\.eBirdNotable, provider)
}
