// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public enum eBirdRegionType: String, CaseIterable, Codable, Sendable {
    case custom
    case country
    case subnational1
    case subnational2
}

public extension eBirdRegionType {
    var subtype: eBirdRegionType? {
        switch self {
        case .custom: .country
        case .country: .subnational1
        case .subnational1: .subnational2
        case .subnational2: nil
        }
    }
}
