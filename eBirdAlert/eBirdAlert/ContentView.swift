// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

struct ContentView: View {
    @ObservedObject var preferences = PreferencesModel.global
    @Environment(\.eBirdNotable) var notableProvider: ObservationsProvider?

    var body: some View {
        TabView {
            Tab("Rarities", systemImage: "bird.circle") {
                ObservationsView(provider: notableProvider!)
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
    let locationService = LocationService()
    let provider =
        ObservationsProvider(client: FakeObservationsClient(),
                             checklistDataService: FakeChecklistDataService(),
                             locationService: locationService)
    ContentView()
        .modelContainer(for: Checklist.self, inMemory: true)
        .environment(locationService)
        .environment(\.eBirdNotable, provider)
}
