// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

@Suite struct ObservationsParsingTest {
    @Test func basic() throws {
        let path = Bundle.module.url(forResource: "20250402T1030",
                                     withExtension: "json")
        try #require(path != nil)
        let json = try Data(contentsOf: #require(path))
        let d = JSONDecoder()
        d.dateDecodingStrategy = .eBirdStyle
        let observations = try d.decode([eBirdObservation].self, from: json)
        #expect(observations.count == 182)
    }
}
