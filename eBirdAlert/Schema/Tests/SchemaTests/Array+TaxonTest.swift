// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

struct ArrayTaxonTest {
    @Test func parse() throws {
        let url = try #require(Bundle.module.url(forResource: "taxonomy",
                                                 withExtension: "json"))
        _ = try [Taxon].from(url)
    }
}
