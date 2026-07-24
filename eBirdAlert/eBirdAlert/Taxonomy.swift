// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import SwiftUtil

class Taxonomy {
    static let global = Taxonomy()

    private lazy var loader: FixedTaxonLoader = {
        let url = Bundle.main.url(forResource: "taxonomy",
                                  withExtension: "csv")!
        return try! FixedTaxonLoader(taxa: .fromCSV(url))
    }()

    func search(string: String) -> [Taxon] {
        loader.search(string: string)
    }

    func find(for speciesCode: String) -> Taxon? {
        loader.find(for: speciesCode)
    }
}
