// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema

extension eBirdRecentObservation: @retroactive Identifiable {
    public var id: String { "\(speciesCode).\(locId)" }
}

extension eBirdRecentObservation: ObservationSortable {
    var taxon: Taxon? { Taxonomy.global.find(for: speciesCode) }

    var taxonOrder: Double {
        taxon?.taxonOrder ?? 9_999_999
    }

    var family: eBirdFamily {
        taxon?.familyCode ?? .unknown
    }
}

extension eBirdRecentObservation: Matchable {
    var matchText: String { comName }
}

extension eBirdRecentObservation: ChecklistDataServiceObservation {}

extension eBirdRecentObservation: eBirdObservationProtocol {}
