// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

struct ObservationsView: View {
    let service = LocationService.global

    var body: some View {
        if let loc = service.location {
            Text("loc: \(loc)")
        } else {
            Text("no location 😢")
        }
    }
}
