// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

class Taxonomy {
    static let global = Taxonomy()

    lazy var taxa: [Taxon] = {
        let url = Bundle.main.url(forResource: "taxonomy",
                                  withExtension: "json")!
        return try! JSONDecoder().decode([Taxon].self,
                                         from: Data(contentsOf: url))
    }()

    func search(string: String) -> [Taxon] {
        taxa.filter { $0.contains(string: string) }
    }

    func find(for speciesCode: String) -> Taxon? {
        let it = taxa.lowerBound(where: { $0.speciesCode < speciesCode })
        guard it != taxa.endIndex,
              taxa[it].speciesCode == speciesCode
        else {
            return nil
        }
        return taxa[it]
    }
}
