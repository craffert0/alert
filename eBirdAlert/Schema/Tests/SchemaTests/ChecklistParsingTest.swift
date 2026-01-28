// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

@Suite struct ChecklistParsingTest {
    @Test func basics() throws {
        for name in ["S222144997", "S222159728", "S222245597", "S273904108"] {
            let path = Bundle.module.url(forResource: name,
                                         withExtension: "json")
            try #require(path != nil)
            let json = try Data(contentsOf: #require(path))
            let d = JSONDecoder()
            d.dateDecodingStrategy = .eBirdStyle
            let checklist = try d.decode(eBirdChecklist.self, from: json)
            #expect(checklist.numSpecies > 0)
        }
    }
}
