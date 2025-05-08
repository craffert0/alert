// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftData
import SwiftUI

struct ContentView: View {
    @ObservedObject var preferences = PreferencesModel.global
    @Environment(\.eBirdNotable) var notableProvider: ObservationsProvider?

    var body: some View {
        TabView {
            Tab("Rarities", systemImage: "bird.circle") {
                MainView(provider: notableProvider!)
            }

            if preferences.debugMode {
                Tab("Checklists", systemImage: "checklist") {
                    ChecklistsView()
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
        ObservationsProvider(client: client,
                             checklistDataService: FakeChecklistDataService(),
                             locationService: locationService)
    ContentView()
        .modelContainer(for: Checklist.self, inMemory: true)
        .environment(locationService)
        .environment(\.eBirdNotable, provider)
}
