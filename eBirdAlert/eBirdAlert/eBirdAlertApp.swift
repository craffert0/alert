// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

@main
struct eBirdAlertApp: App {
    @State var locationService: LocationService
    @State var notableProvider: ObservationsProvider

    init() {
        let client = NotableObservationsClient(service: URLSession.shared)
        let locationService = LocationService()
        self.locationService = locationService
        notableProvider =
            ObservationsProvider(client: client,
                                 locationService: locationService)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(locationService)
                .environment(\.eBirdNotable, notableProvider)
        }
    }
}
