// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

struct ContentView: View {
    @ObservedObject var preferences = PreferencesModel.global

    var body: some View {
        TabView {
            Tab("Rarities", systemImage: "bird.circle") {
                NotableObservationsView()
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
    ContentView()
        .modelContainer(for: Checklist.self, inMemory: true)
}
