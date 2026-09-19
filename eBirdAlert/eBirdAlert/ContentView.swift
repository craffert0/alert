// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

struct ContentView: View {
    @ObservedObject var preferences = PreferencesModel.global
    @State var mergedModel: MergedModel
    @State private var selectedTab: TabKind = .rarities
    private let center = NotificationCenter.default

    var body: some View {
        TabView(selection: $selectedTab) {
            NotablesView()
                .tabItem {
                    Label("Rarities", systemImage: "bird")
                }
                .tag(TabKind.rarities)

            LocalsView()
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
        .alert(isPresented: $mergedModel.showError, error: mergedModel.error) { _ in
        } message: { e in
            e.view
        }
    }
}
