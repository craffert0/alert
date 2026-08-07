// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import SwiftUtil

public struct FixedTaxonLoader {
    private let taxa: [Taxon]

    public init(taxa: [Taxon]) {
        self.taxa = taxa
    }

    public func search(string: String) -> [Taxon] {
        taxa.filter { $0.contains(string: string) }
    }

    public func find(for speciesCode: String) -> Taxon? {
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
