// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
@testable import Schema

struct FakeObservationSortable: Decodable {
    var comName: String
    var obsDt: Date
    var taxonOffset: Int
    var family: eBirdFamily
}

extension FakeObservationSortable: ObservationSortable {
    var taxonOrder: Double { Double(1000 * family.sortKey + taxonOffset) }
}

extension [FakeObservationSortable] {
    func sorted(_ option: ObservationSortOption)
        -> ObservationSortResult<FakeObservationSortable>
    {
        option.sort(self)
    }
}
