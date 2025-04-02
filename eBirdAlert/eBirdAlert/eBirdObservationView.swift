// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct eBirdObservationView: View {
    let e: eBirdObservation

    init(_ e: eBirdObservation) {
        self.e = e
    }

    var body: some View {
        Text(e.comName)
    }
}
