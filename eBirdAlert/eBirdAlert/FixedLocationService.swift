// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema

// periphery:ignore - used in #Preview
class FixedLocationService: LocationService {
    init(latitude: Double, longitude: Double) {
        super.init()
        location = Coordinate(latitude: latitude,
                              longitude: longitude)
    }
}
