// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import Schema

public extension Coordinate {
    init(from location: CLLocationCoordinate2D) {
        self.init(latitude: location.latitude,
                  longitude: location.longitude)
    }

    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2DMake(latitude, longitude)
    }
}

public extension [Coordinate] {
    var locations: [CLLocationCoordinate2D] {
        map(\.location)
    }
}
