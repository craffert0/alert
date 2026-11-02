// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

struct ContentView: View {
    @ObservedObject var preferences = PreferencesModel.global
    let notablesViewModel: NotablesViewModel
    let localsViewModel: LocalsViewModel
    @State private var selectedTab: TabKind = .rarities
    private let center = NotificationCenter.default

    var body: some View {
        TabView(selection: $selectedTab) {
            NotablesView(model: notablesViewModel)
                .tabItem {
                    Label("Rarities", systemImage: "bird")
                }
                .tag(TabKind.rarities)

            LocalsView(model: localsViewModel)
                .tabItem { Label("Locals", systemImage: "globe") }
                .tag(TabKind.locals)

            if preferences.debugMode {
                DebugView()
                    .tabItem {
                        Label("Debug", systemImage: "ladybug")
                    }
                    .tag(TabKind.debug)
            }

            PreferencesView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(TabKind.settings)
        }
        .onReceive(center.publisher(for: .navigateToTab)) { notification in
            if let tab = notification.object as? TabKind {
                selectedTab = tab
            }
        }
    }
}
