// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation

public struct CircleModel {
    public let location: CLLocation
    public let radius: Double
    public let units: DistanceUnits

    public init(location: CLLocation,
                radius: Double,
                units: DistanceUnits)
    {
        self.location = location
        self.radius = radius
        self.units = units
    }
}
