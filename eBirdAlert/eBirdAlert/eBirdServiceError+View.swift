// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import SwiftUI
import URLNetwork

extension eBirdServiceError {
    var view: some View {
        Text(viewText)
    }

    private var viewText: String {
        switch self {
        case let .expandedArea(distance, units):
            "eBird could not find birds in the original range," +
                " so we expanded the range to " +
                distance.formatted(.eBirdFormat) + " " +
                units.rawValue + " in order to find some."
        default:
            ""
        }
    }
}
