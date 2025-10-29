// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftData
import SwiftUI

@main
struct eBirdAlertApp: App {
    let modelContainer: ModelContainer
    @State var swiftDataService: SwiftDataService
    @State var locationService: LocationService
    @State var notableProvider: ObservationsProvider
    @State var recentProvider: RecentObservationsProvider

    init() {
        let modelContainer =
            try! ModelContainer(for: Checklist.self, DebugLine.self)
        let client = NotableObservationsClient(service: URLSession.shared)
        let swiftDataService =
            SwiftDataService(modelContext: modelContainer.mainContext)
        let locationService = CoreLocationService()
        let notableProvider =
            ObservationsProvider(client: client,
                                 checklistDataService: swiftDataService,
                                 locationService: locationService)

        let recentProvider =
            RecentObservationsProvider(
                client: RecentObservationsClient(service: URLSession.shared),
                locationService: locationService
            )

        self.modelContainer = modelContainer
        self.swiftDataService = swiftDataService
        self.locationService = locationService
        self.notableProvider = notableProvider
        self.recentProvider = recentProvider

        Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { _ in
            swiftDataService.garbageCollect(daysBack: 8)
        }.fire()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
                .environment(swiftDataService)
                .environment(locationService)
                .environment(\.eBirdNotable, notableProvider)
                .environment(\.eBirdAll, recentProvider)
        }
    }
}
