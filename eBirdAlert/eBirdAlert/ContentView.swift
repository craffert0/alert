// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftData
import SwiftUI

struct ContentView: View {
    @ObservedObject var preferences = PreferencesModel.global
    private let notableProvider: NotableObservationsProvider
    private let recentProvider: RecentObservationsProvider
    private let notablesModel: NotablesModel
    private let localsModel: LocalsModel
    @State private var selectedTab: TabKind = .rarities
    private let center = NotificationCenter.default

    init(locationService: LocationService,
         swiftDataService: SwiftDataService,
         notableProvider: NotableObservationsProvider,
         recentProvider: RecentObservationsProvider)
    {
        self.notableProvider = notableProvider
        self.recentProvider = recentProvider
        notablesModel = .init(provider: notableProvider,
                              locationService: locationService,
                              swiftDataService: swiftDataService)
        localsModel = .init(provider: recentProvider,
                            locationService: locationService,
                            swiftDataService: swiftDataService)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NotablesView(model: notablesModel)
                .tabItem {
                    Label("Rarities", systemImage: "environments.circle")
                }
                .tag(TabKind.rarities)

            LocalsView(model: localsModel)
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
        .onReceive(center.publisher(for: .navigateToTab)) { notification in
            if let tab = notification.object as? TabKind {
                selectedTab = tab
                Task { @MainActor in
                    switch tab {
                    case .rarities: try? await notableProvider.refresh()
                    case .locals: try? await recentProvider.refresh()
                    default: break
                    }
                }
            }
        }
    }
}
