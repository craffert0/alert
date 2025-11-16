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
        let minX: Double
        let maxX: Double
        let minY: Double
        let maxY: Double
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

// {
//   "bounds": {
//     "minX": -74.0420379999999,
//     "maxX": -73.853798,
//     "minY": 40.570752,
//     "maxY": 40.739551
//   },
//   "result": "Kings, New York, United States",
//   "code": "US-NY-047",
//   "type": "subnational2",
//   "parent": {
//     "result": "New York, United States",
//     "code": "US-NY",
//     "type": "subnational1",
//     "parent": {
//       "result": "United States",
//       "code": "US",
//       "type": "country",
//       "longitude": 0.0,
//       "latitude": 0.0
//     },
//     "longitude": 0.0,
//     "latitude": 0.0
//   },
//   "longitude": -73.94791799999996,
//   "latitude": 40.6551515
// }
