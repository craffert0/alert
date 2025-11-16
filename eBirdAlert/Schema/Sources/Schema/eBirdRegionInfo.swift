// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import Foundation

public struct eBirdRegionInfo: Codable, Sendable {
    public let bounds: Bounds?
    public let result: String
    public let code: String
    public let type: eBirdRegionType
    // public let parent: Parent?
    public let longitude: Double
    public let latitude: Double

    public struct Bounds: Codable, Sendable {
        public let minX: Double
        public let maxX: Double
        public let minY: Double
        public let maxY: Double
    }
}

extension eBirdRegionInfo: Identifiable {
    public var id: String { code }
}

extension eBirdRegionInfo {
    func contains(_ location: CLLocation) -> Bool {
        guard let bounds else { return true }
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        return
            bounds.minX - 0.14 <= lng &&
            lng <= bounds.maxX + 0.14 &&
            bounds.minY - 0.14 <= lat &&
            lat <= bounds.maxY + 0.14
    }
}

public extension eBirdRegionInfo.Bounds {
    static let us = eBirdRegionInfo.Bounds(
        minX: -179.150558,
        maxX: 179.773408,
        minY: 18.909858,
        maxY: 71.390685
    )

    static let ny = eBirdRegionInfo.Bounds(
        minX: -79.7633299999999,
        maxX: -71.856354,
        minY: 40.496169,
        maxY: 45.010991
    )

    static let kings = eBirdRegionInfo.Bounds(
        minX: -74.0420379999999,
        maxX: -73.853798,
        minY: 40.570752,
        maxY: 40.739551
    )
}

public extension eBirdRegionInfo {
    static let xx = eBirdRegionInfo(
        bounds: nil,
        result: "High Seas",
        code: "XX",
        type: .country,
        longitude: 0.0,
        latitude: 0.0
    )

    static let us = eBirdRegionInfo(
        bounds: .us,
        result: "United States",
        code: "US",
        type: .country,
        longitude: 0.31142499999999984,
        latitude: 45.1502715
    )

    static let ny = eBirdRegionInfo(
        bounds: .ny,
        result: "New York, United States",
        code: "US-NY",
        type: .subnational1,
        // "parent": {
        //     "result": "United States",
        //     "code": "US",
        //     "type": "country",
        //     "longitude": 0.0,
        //     "latitude": 0.0
        // },
        longitude: -75.80984199999995,
        latitude: 42.75358
    )

    static let kings = eBirdRegionInfo(
        bounds: .kings,
        result: "Kings, New York, United States",
        code: "US-NY-047",
        type: .subnational2,
        // "parent": {
        //     "result": "New York, United States",
        //     "code": "US-NY",
        //     "type": "subnational1",
        //     "parent": {
        //         "result": "United States",
        //         "code": "US",
        //         "type": "country",
        //         "longitude": 0.0,
        //         "latitude": 0.0
        //     },
        //     "longitude": 0.0,
        //     "latitude": 0.0
        // },
        longitude: -73.94791799999996,
        latitude: 40.6551515
    )
}
