// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public extension eBirdRegionInfo.Bounds {
    static let us = eBirdRegionInfo.Bounds(
        minX: -179.150558,
        maxX: 179.773408,
        minY: 18.909858,
        maxY: 71.390685
    )

    static let ny = eBirdRegionInfo.Bounds(
        minX: -79.76333,
        maxX: -71.856354,
        minY: 40.496169,
        maxY: 45.010991
    )

    static let kings = eBirdRegionInfo.Bounds(
        minX: -74.042038,
        maxX: -73.853798,
        minY: 40.570752,
        maxY: 40.739551
    )

    static let queens = eBirdRegionInfo.Bounds(
        minX: -73.969719,
        maxX: -73.704193,
        minY: 40.542167,
        maxY: 40.801049
    )
}

public extension eBirdRegionInfo {
    static let xx = eBirdRegionInfo(
        result: "High Seas",
        code: "XX",
        type: .country
    )

    static let us = eBirdRegionInfo(
        bounds: .us,
        result: "United States",
        code: "US",
        type: .country,
        longitude: 0.311425,
        latitude: 45.1502715
    )

    static let ny = eBirdRegionInfo(
        bounds: .ny,
        result: "New York, United States",
        code: "US-NY",
        type: .subnational1,
        parent: .us,
        longitude: -75.809842,
        latitude: 42.75358
    )

    static let kings = eBirdRegionInfo(
        bounds: .kings,
        result: "Kings, New York, United States",
        code: "US-NY-047",
        type: .subnational2,
        parent: .ny,
        longitude: -73.947918,
        latitude: 40.6551515
    )

    static let queens = eBirdRegionInfo(
        bounds: .queens,
        result: "Queens, New York, United States",
        code: "US-NY-081",
        type: .subnational2,
        parent: .ny,
        longitude: -73.836956,
        latitude: 40.671608
    )
}
