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
    var diamond: [Coordinate] {
        let dX = maxX - minX
        let lX = minX + dX / 4
        let rX = minX + 3 * dX / 4
        let dY = maxY - minY
        let lY = minY + dY / 4
        let hY = minY + 3 * dY / 4
        return [
            Coordinate(latitude: maxY, longitude: lX),
            Coordinate(latitude: maxY, longitude: rX),
            Coordinate(latitude: hY, longitude: maxX),
            Coordinate(latitude: lY, longitude: maxX),
            Coordinate(latitude: minY, longitude: rX),
            Coordinate(latitude: minY, longitude: lX),
            Coordinate(latitude: lY, longitude: minX),
            Coordinate(latitude: hY, longitude: minX),
            Coordinate(latitude: maxY, longitude: lX),
        ]
    }

    /** return square of the shortest distance from c to self */
    func distance2(_ c: Coordinate) -> Double {
        // https://stackoverflow.com/a/18157551
        let dx = max(minX - c.longitude, 0, c.longitude - maxX)
        let dy = max(minY - c.latitude, 0, c.latitude - maxY)
        return dx * dx + dy * dy
    }
}
