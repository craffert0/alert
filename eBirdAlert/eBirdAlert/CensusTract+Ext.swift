// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema

extension CensusTract: @retroactive RegionCodeProvider {
    public var code: String {
        "US-\(state_code)-\(county_fips.suffix(3))"
    }
}
