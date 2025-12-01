// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema

extension eBirdRegionInfo {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    /** return square of the distance */
    func distance2(_ location: CLLocation) -> Double? {
        bounds?.distance2(location)
    }
}

extension eBirdRegionInfo.Bounds {
    var coordinates: [CLLocationCoordinate2D] {
        [
            CLLocationCoordinate2D(latitude: minY, longitude: minX),
            CLLocationCoordinate2D(latitude: minY, longitude: maxX),
            CLLocationCoordinate2D(latitude: maxY, longitude: maxX),
            CLLocationCoordinate2D(latitude: maxY, longitude: minX),
            CLLocationCoordinate2D(latitude: minY, longitude: minX),
        ]
    }

    /** return square of the distance */
    func distance2(_ location: CLLocation) -> Double {
        // https://stackoverflow.com/a/18157551
        let c = location.coordinate
        let dx = max(minX - c.longitude, 0, c.longitude - maxX)
        let dy = max(minY - c.latitude, 0, c.latitude - maxY)
        return dx * dx + dy * dy
    }
}
