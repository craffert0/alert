// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

public extension Components.Schemas.Range {
    var model: RangeType {
        switch self {
        case let .RegionInfo(info):
            .region(info.model)
        case let .Circle(circle):
            .radius(circle.model)
        }
    }
}

public extension Components.Schemas.RegionInfo {
    var model: eBirdRegionInfo {
        .init(result: result,
              code: code,
              type: .init(rawValue: _type.rawValue)!)
    }
}

public extension Components.Schemas.Circle {
    var model: CircleModel {
        .init(location: location.model,
              radius: radius,
              units: .init(rawValue: units.rawValue)!)
    }
}

public extension Components.Schemas.Location {
    var model: Coordinate {
        .init(latitude: lat, longitude: lng)
    }
}

// ----------------------------------------------------------------

public extension RangeType {
    var api: Components.Schemas.Range {
        switch self {
        case let .region(info):
            .RegionInfo(info.api)
        case let .radius(circle):
            .Circle(circle.api)
        }
    }
}

public extension eBirdRegionInfo {
    var api: Components.Schemas.RegionInfo {
        .init(result: result,
              code: code,
              _type: .init(rawValue: type.rawValue)!)
    }
}

public extension CircleModel {
    var api: Components.Schemas.Circle {
        .init(location: location.api,
              radius: radius,
              units: .init(rawValue: units.rawValue)!)
    }
}

public extension Coordinate {
    var api: Components.Schemas.Location {
        .init(lat: latitude, lng: longitude)
    }
}
