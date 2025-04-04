// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Rarities", systemImage: "bird.circle") {
                NotableObservationsView()
            }

            Tab("Checklists", systemImage: "checklist") {
                ChecklistsView()
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
