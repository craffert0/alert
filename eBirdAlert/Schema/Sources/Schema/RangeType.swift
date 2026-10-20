// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public enum RangeType: Codable, Sendable {
    case region(eBirdRegionInfo)
    case radius(CircleModel)
}

public extension RangeType {
    var timeZone: TimeZone {
        get async {
            switch self {
            case let .region(region):
                await TimeZone.from(latitude: region.latitude,
                                    longitude: region.longitude)
            case let .radius(circle):
                await TimeZone.from(latitude: circle.location.latitude,
                                    longitude: circle.location.longitude)
            }
        }
    }
}
