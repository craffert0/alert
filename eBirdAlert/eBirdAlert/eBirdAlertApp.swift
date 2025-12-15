// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftData
import SwiftUI

@main
struct eBirdAlertApp: App {
    @Environment(\.scenePhase) private var scenePhase
    let modelContainer: ModelContainer
    @State var swiftDataService: SwiftDataService
    @State var locationService: LocationService
    @State var notableProvider: NotableObservationsProvider
    @State var recentProvider: RecentObservationsProvider
    let notificationService = NotificationService()
    let refreshService: RefreshService

    init() {
        let modelContainer =
            try! ModelContainer(for: Checklist.self, DebugLine.self)
        let client = NotableObservationsClient(service: URLSession.shared)
        let swiftDataService =
            SwiftDataService(modelContext: modelContainer.mainContext)
        let locationService = CoreLocationService()
        let notableProvider =
            NotableObservationsProvider(client: client,
                                        checklistDataService: swiftDataService,
                                        locationService: locationService)

        let recentProvider =
            RecentObservationsProvider(
                client: RecentObservationsClient(service: URLSession.shared),
                checklistDataService: swiftDataService,
                locationService: locationService
            )

        self.modelContainer = modelContainer
        self.swiftDataService = swiftDataService
        self.locationService = locationService
        self.notableProvider = notableProvider
        self.recentProvider = recentProvider
        refreshService =
            RefreshService(notificationService: notificationService)

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
        .backgroundTask(.appRefresh(id: .refreshCounter)) {
            try? await refreshService.refresh()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background,
               PreferencesModel.global.notifyNotable
            {
                try? refreshService.schedule()
            }
        }
    }
}
