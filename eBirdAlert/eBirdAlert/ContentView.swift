// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Items", systemImage: "tray.and.arrow.up.fill") {
                ItemsView()
            }

            Tab("Prefs", systemImage: "person.crop.circle.fill") {
                PreferencesView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
