// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public struct CircleModel: Codable, Sendable {
    public let location: Coordinate
    public let radius: Double
    public let units: DistanceUnits

    public init(location: Coordinate,
                radius: Double,
                units: DistanceUnits)
    {
        self.location = location
        self.radius = radius
        self.units = units
    }
}
