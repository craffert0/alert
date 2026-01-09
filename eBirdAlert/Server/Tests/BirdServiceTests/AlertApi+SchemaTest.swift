// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
@testable import BirdService
import Foundation
import Schema
import Testing

typealias Circle = Components.Schemas.Circle
typealias RegionInfo = Components.Schemas.RegionInfo
typealias Range = Components.Schemas.Range

@Suite struct AlertApiSchemaTest {
    @Test func circle() {
        let expected: RangeType =
            .radius(.init(location: .init(latitude: 73,
                                          longitude: 43),
                          radius: 10,
                          units: .miles))
        #expect(expected.api.model.api == expected.api)
    }
}
