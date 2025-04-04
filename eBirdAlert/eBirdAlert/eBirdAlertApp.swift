// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftData
import SwiftUI

@main
struct eBirdAlertApp: App {
    @State var notableProvider =
        NotableObservationsProvider(
            client: NotableObservationsClient(service: URLSession.shared))

    var body: some Scene {
        WindowGroup {
            ContentView().environment(notableProvider)
        }
    }
}
