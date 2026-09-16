// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema

struct LookupOption {
    let range: RangeValue
    let daysBack: Int

    enum RangeValue {
        case radius(Double, DistanceUnits)
        case region(String?)
    }
}

extension LookupOption.RangeValue: Equatable {}
extension LookupOption: Equatable {}
