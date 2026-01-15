// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import CoreLocation

public struct Coordinate: Codable, Sendable, Equatable {
    public let latitude: Double
    public let longitude: Double

    public var location: CLLocationCoordinate2D {
        CLLocationCoordinate2DMake(latitude, longitude)
    }

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public extension [Coordinate] {
    var locations: [CLLocationCoordinate2D] {
        map(\.location)
    }
}
