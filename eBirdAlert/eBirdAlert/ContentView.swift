// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftData
import SwiftUI

struct ContentView: View {
    @ObservedObject var preferences = PreferencesModel.global
    let swiftDataService: SwiftDataService
    let mergedModel: MergedModel
    @State private var selectedTab: TabKind = .rarities

    var body: some View {
        TabView(selection: $selectedTab) {
            NotablesView(model: mergedModel)
                .tabItem {
                    Label("Rarities", systemImage: "environments.circle")
                }
                .tag(TabKind.rarities)

            LocalsView(model: mergedModel,
                       swiftDataService: swiftDataService)
                .tabItem { Label("Locals", systemImage: "bird.circle") }
                .tag(TabKind.locals)

            if preferences.debugMode {
                DebugView()
                    .tabItem {
                        Label("Debug", systemImage: "ladybug.circle.fill")
                    }
                    .tag(TabKind.debug)
            }

            PreferencesView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(TabKind.settings)
        }
    }
}
