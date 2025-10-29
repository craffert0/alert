// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct RecentBirdView: View {
    let o: eBirdRecentObservation

    var body: some View {
        VStack {
            Text(o.sciName)
            Spacer()

            BirdButtonsView(speciesCode: o.speciesCode)

            Text(o.comName)
            Spacer()
        }
        .navigationTitle(o.comName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    VStack {
        RecentBirdView(o: .fake)
    }
}
