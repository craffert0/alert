// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema

extension ObservationSortOption {
    var viewString: String { rawValue }

    var shortString: String {
        switch self {
        case .byTime: "Time"
        case .byName: "Name"
        case .byTaxon: "Family"
        }
    }
}
