// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension BirdObservations: @retroactive Identifiable {
    public var id: String { speciesCode }
}

extension BirdObservations: ObservationSortable {
    var taxon: Taxon? { Taxonomy.global.find(for: speciesCode) }

    var taxonOrder: Double {
        taxon?.taxonOrder ?? 9_999_999
    }

    var family: eBirdFamily {
        taxon?.familyCode ?? .unknown
    }

    public var obsDt: Date { latestSighting }
}

extension BirdObservations: Matchable {
    var matchText: String { comName }
}
