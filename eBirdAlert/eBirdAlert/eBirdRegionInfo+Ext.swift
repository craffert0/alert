// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema

extension eBirdRegionInfo {
    var coordinate: Coordinate {
        Coordinate(latitude: latitude, longitude: longitude)
    }

    /** return square of the distance */
    func distance2(_ location: Coordinate) -> Double? {
        bounds?.distance2(location)
    }
}

extension eBirdRegionInfo.Bounds {
    var coordinates: [Coordinate] {
        [
            Coordinate(latitude: minY, longitude: minX),
            Coordinate(latitude: minY, longitude: maxX),
            Coordinate(latitude: maxY, longitude: maxX),
            Coordinate(latitude: maxY, longitude: minX),
            Coordinate(latitude: minY, longitude: minX),
        ]
    }

    /** return square of the distance */
    func distance2(_ c: Coordinate) -> Double {
        // https://stackoverflow.com/a/18157551
        let dx = max(minX - c.longitude, 0, c.longitude - maxX)
        let dy = max(minY - c.latitude, 0, c.latitude - maxY)
        return dx * dx + dy * dy
    }
}
