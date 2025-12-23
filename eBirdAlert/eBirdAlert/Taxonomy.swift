// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import SwiftUtil

class Taxonomy {
    static let global = Taxonomy()

    lazy var taxa: [Taxon] = {
        let url = Bundle.main.url(forResource: "taxonomy",
                                  withExtension: "json")!
        return try! .from(url)
    }()

    func search(string: String) -> [Taxon] {
        taxa.filter { $0.contains(string: string) }
    }

    func find(for speciesCode: String) -> Taxon? {
        let it = taxa.lowerBound(of: speciesCode,
                                 comp: { $0.speciesCode < $1 })
        guard it != taxa.endIndex,
              taxa[it].speciesCode == speciesCode
        else {
            return nil
        }
        return taxa[it]
    }
}
