// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema

extension eBirdRegionInfo {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
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
}
