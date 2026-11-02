// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftData
import SwiftUI

@main
struct eBirdAlertApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    let modelContainer: ModelContainer
    @State var swiftDataService: SwiftDataService
    @State var locationService: LocationService
    @State var mergedModel: MergedModel
    let notificationService = NotificationService()
    let refreshService: RefreshService

    init() {
        String.markdownProtocol = PreferencesStringMarkdown()

        let modelContainer =
            try! ModelContainer(for: Schema(SchemaV1.models))
        let swiftDataService =
            SwiftDataService(modelContext: modelContainer.mainContext)
        let locationService = CoreLocationService()

        let mergedModel = MergedModel(
            locationService: locationService,
            notableProvider: .init(service: eBirdServiceGlobal,
                                   checklistDataService: swiftDataService,
                                   locationService: locationService,
                                   remoteNotificationService: RemoteNotificationService()),
            recentProvider: .init(service: eBirdServiceGlobal,
                                  checklistDataService: swiftDataService,
                                  locationService: locationService)
        )

        let refreshService =
            RefreshService(notificationService: notificationService,
                           mergedModel: mergedModel)

        self.modelContainer = modelContainer
        self.swiftDataService = swiftDataService
        self.locationService = locationService
        self.refreshService = refreshService
        self.mergedModel = mergedModel

        Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { _ in
            swiftDataService.garbageCollect(daysBack: 8)
        }.fire()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(mergedModel: mergedModel)
                .modelContainer(modelContainer)
                .environment(swiftDataService)
                .environment(locationService)
                .environment(notificationService)
                .environment(mergedModel)
        }
        .backgroundTask(.appRefresh(id: .refreshCounter)) {
            try? await refreshService.refresh()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background,
               case .local = PreferencesModel.global.notificationType
            {
                try? refreshService.schedule()
            }
        }
    }
}
