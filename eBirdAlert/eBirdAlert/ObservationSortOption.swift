// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema

enum ObservationSortOption: String {
    case byTime = "By Time"
    case byName = "By Name"
    case byTaxon = "By Taxon"
}

extension ObservationSortOption: CaseIterable, Identifiable {
    var id: Self { self }
}

extension ObservationSortOption {
    var viewString: String {
        switch self {
        case .byTime: "By Time"
        case .byName: "By Name"
        case .byTaxon: "By Family"
        }
    }
}

extension ObservationSortOption {
    func sort<T: ObservationSortable>(_ observations: [T]) -> [T] {
        switch self {
        case .byName:
            observations.sorted { a, b in
                a.comName < b.comName
            }
        case .byTime:
            observations.sorted { a, b in
                a.obsDt > b.obsDt
            }
        case .byTaxon:
            observations.sorted { a, b in
                a.taxonOrder < b.taxonOrder
            }
        }
    }

    func group<T: ObservationSortable>(_ observations: [T])
        -> [(eBirdFamily, [T])]?
    {
        guard self == .byTaxon else { return nil }
        return Dictionary(grouping: observations) {
            $0.family
        }.sorted {
            $0.key < $1.key
        }.map {
            ($0.key, sort($0.value))
        }
    }
}
