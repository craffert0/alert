// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
import Foundation
import Schema

extension Components.Schemas.Range {
    var model: RangeType {
        switch self {
        case let .RegionInfo(info):
            .region(info.model)
        case let .Circle(circle):
            .radius(circle.model)
        }
    }
}

extension Components.Schemas.RegionInfo {
    var model: eBirdRegionInfo {
        .init(result: result,
              code: code,
              type: .init(rawValue: _type.rawValue)!)
    }
}

extension Components.Schemas.Circle {
    var model: CircleModel {
        .init(location: location.model,
              radius: radius,
              units: .init(rawValue: units.rawValue)!)
    }
}

extension Components.Schemas.Location {
    var model: Coordinate {
        .init(latitude: lat, longitude: lng)
    }
}

// ----------------------------------------------------------------

extension RangeType {
    var api: Components.Schemas.Range {
        switch self {
        case let .region(info):
            .RegionInfo(info.api)
        case let .radius(circle):
            .Circle(circle.api)
        }
    }
}

extension eBirdRegionInfo {
    var api: Components.Schemas.RegionInfo {
        .init(result: result,
              code: code,
              _type: .init(rawValue: type.rawValue)!)
    }
}

extension CircleModel {
    var api: Components.Schemas.Circle {
        .init(location: location.api,
              radius: radius,
              units: .init(rawValue: units.rawValue)!)
    }
}

extension Coordinate {
    var api: Components.Schemas.Location {
        .init(lat: latitude, lng: longitude)
    }
}
