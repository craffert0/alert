// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema

public extension DistanceUnits {
    func asMeters(_ value: Double) -> Double {
        1000 * asKilometers(value)
    }

    // periphery:ignore - just for fun
    func asFeet(_ value: Double) -> Double {
        5280 * asMiles(value)
    }
}
