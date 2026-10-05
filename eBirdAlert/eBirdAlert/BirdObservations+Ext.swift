// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension BirdObservations: @retroactive Identifiable {
    public var id: String { speciesCode }
}

extension BirdObservations: @retroactive ObservationSortable {
    var taxon: Taxon? { Taxonomy.global.find(for: speciesCode) }

    public var taxonOrder: Double {
        taxon?.taxonOrder ?? 9_999_999
    }

    public var family: eBirdFamily {
        taxon?.familyCode ?? .unknown
    }

    public var obsDt: Date { latestSighting }
}

extension BirdObservations: Matchable {
    var matchText: String { comName }
}

extension BirdObservations: @retroactive Equatable {
    public static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.speciesCode == rhs.speciesCode && lhs.locations == rhs.locations
    }
}

extension BirdObservations: MergedContentProtocol {}
