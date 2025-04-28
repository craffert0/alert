// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct LocationButton: View {
    @State var location: LocationProtocol

    var body: some View {
        Button(location.locName) {
            location.openMap()
        }
    }
}

private class FakeLocation: LocationProtocol {
    let locName = "here"
    let lat = 40.7
    let lng = -74.0
}

#Preview {
    VStack {
        LocationButton(location: FakeLocation())
    }
}
