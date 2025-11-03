// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema

enum ObservationSortOption: String {
    case byTime = "By Time"
    case byName = "By Name"
}

extension ObservationSortOption: CaseIterable, Identifiable {
    var id: Self { self }
}

extension ObservationSortOption {
    func sort(_ observations: [eBirdRecentObservation])
        -> [eBirdRecentObservation]
    {
        if self == .byName {
            observations.sorted { a, b in
                a.comName < b.comName
            }
        } else {
            observations.sorted { a, b in
                a.obsDt > b.obsDt
            }
        }
    }
}
