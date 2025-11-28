// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

@Suite struct DistanceUnitsTest {
    @Test func asMiles() {
        #expect(DistanceUnits.miles.asMiles(10) == 10)
        #expect(abs(DistanceUnits.kilometers.asMiles(10) - 6.2) < 0.1)
    }

    @Test func asKilometers() {
        #expect(abs(DistanceUnits.miles.asKilometers(10) - 16.1) < 0.1)
        #expect(DistanceUnits.kilometers.asKilometers(10) == 10)
    }
}
