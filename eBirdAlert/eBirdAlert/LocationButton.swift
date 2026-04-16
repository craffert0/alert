// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct LocationButton: View {
    @State var location: LocationProtocol
    @State var showHotspot: Bool = false

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

private class FakeLocation: LocationProtocol {
    let locName = "here"
    let lat = 40.7
    let lng = -74.0
    let hotspotId: String? = nil
}

#Preview {
    VStack {
        LocationButton(location: FakeLocation())
    }
}
