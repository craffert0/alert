// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public struct CensusTract: Codable, Sendable {
    // There's a bunch of other fields, but we don't care.
    public let bbox: [Double] // [-73.98, 40.66, -73.96, 40.67]
    public let county_fips: String // "36047" or "02290"
    public let county_name: String // "Kings County",
    public let state_fips: String // "36" or "02"
    public let state_code: String // "NY" or "AK"
    public let state_name: String // "New York",
}
