// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

public struct Coordinate: Codable, Sendable, Equatable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public extension Coordinate {
    init(from info: eBirdRegionInfo) {
        self.init(latitude: info.latitude,
                  longitude: info.longitude)
    }
}

public extension Coordinate {
    /** return square of the distance from c to self */
    func distance2(_ c: Coordinate) -> Double {
        let dx = c.longitude - longitude
        let dy = c.latitude - latitude
        return dx * dx + dy * dy
    }
}
