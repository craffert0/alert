// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

extension eBirdRegionInfo {
    var nameView: some View {
        ViewThatFits {
            Text(fullName)
            Text(regionalName)
            Text(shortName)
        }
    }
}

#Preview {
    VStack {
        eBirdRegionInfo.kings.nameView
            .frame(maxWidth: 400)
        eBirdRegionInfo.kings.nameView
            .frame(maxWidth: 200)
        eBirdRegionInfo.kings.nameView
            .frame(maxWidth: 50)
    }
}
