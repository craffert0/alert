// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct LocationButton: View {
    let location: LocationProtocol
    @State private var showHotspot: Bool = false

    var body: some View {
        if let hotspotId = location.hotspotId {
            Button(location.locName) {
                showHotspot = true
            }.sheet(isPresented: $showHotspot) {
                SafariView(hotspotId: hotspotId)
            }
        } else {
            Button(location.locName) {
                location.openMap()
            }
        }
    }
}

#Preview {
    VStack {
        LocationButton(location: eBirdObservation.fake)
    }
}
