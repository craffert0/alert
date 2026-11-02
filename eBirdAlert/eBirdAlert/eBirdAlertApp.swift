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
    @State var notablesViewModel: NotablesViewModel
    @State var localsViewModel: LocalsViewModel
    let notificationService = NotificationService()
    let refreshService: RefreshService

    init() {
        String.markdownProtocol = PreferencesStringMarkdown()

        let modelContainer =
            try! ModelContainer(for: Schema(SchemaV1.models))
        let swiftDataService =
            SwiftDataService(modelContext: modelContainer.mainContext)
        let locationService = CoreLocationService()

        let notablesViewModel = NotablesViewModel(
            provider: .init(service: eBirdServiceGlobal,
                            checklistDataService: swiftDataService,
                            locationService: locationService,
                            remoteNotificationService: RemoteNotificationService())
        )

        let localsViewModel = LocalsViewModel(
            locationService: locationService,
            provider: .init(service: eBirdServiceGlobal,
                            checklistDataService: swiftDataService,
                            locationService: locationService)
        )

        let refreshService =
            RefreshService(notificationService: notificationService,
                           notablesViewModel: notablesViewModel)

        self.modelContainer = modelContainer
        self.swiftDataService = swiftDataService
        self.locationService = locationService
        self.refreshService = refreshService
        self.notablesViewModel = notablesViewModel
        self.localsViewModel = localsViewModel

        Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { _ in
            swiftDataService.garbageCollect(daysBack: 8)
        }.fire()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(notablesViewModel: notablesViewModel,
                        localsViewModel: localsViewModel)
                .modelContainer(modelContainer)
                .environment(swiftDataService)
                .environment(locationService)
                .environment(notificationService)
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
