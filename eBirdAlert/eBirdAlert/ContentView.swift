// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftData
import SwiftUI

struct ContentView: View {
    @ObservedObject var preferences = PreferencesModel.global
    @Environment(\.eBirdNotable)
    var notableProvider: NotableObservationsProvider?
    @Environment(\.eBirdAll)
    var recentObservationsProvider: RecentObservationsProvider?
    @State private var selectedTab: TabKind = .rarities
    private let center = NotificationCenter.default

    var body: some View {
        TabView(selection: $selectedTab) {
            NotableObservationsView(provider: notableProvider!)
                .tabItem {
                    Label("Rarities", systemImage: "environments.circle")
                }
                .tag(TabKind.rarities)

            RecentObservationsView(provider: recentObservationsProvider!)
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
                    case .rarities: try? await notableProvider?.refresh()
                    case .locals: try? await recentObservationsProvider?.refresh()
                    default: break
                    }
                }
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
