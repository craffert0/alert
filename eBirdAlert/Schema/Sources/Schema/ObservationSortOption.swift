// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public enum ObservationSortOption: String {
    case byTime = "By Time"
    case byName = "By Name"
    case byTaxon = "By Taxon"
}

extension ObservationSortOption: CaseIterable, Identifiable {
    public var id: Self { self }
}

public extension ObservationSortOption {
    func sort<T: ObservationSortable>(_ observations: [T])
        -> ObservationSortResult<T>
    {
        switch self {
        case .byName:
            .sorted(
                observations.sorted { a, b in
                    a.comName < b.comName
                }
            )

        case .byTime:
            .sorted(
                observations.sorted { a, b in
                    a.obsDt > b.obsDt
                }
            )

        case .byTaxon:
            .grouped(
                Dictionary(grouping: observations) {
                    $0.family
                }.sorted {
                    $0.key < $1.key
                }.map {
                    (
                        $0.key,
                        $0.value.sorted { a, b in
                            a.taxonOrder < b.taxonOrder
                        }
                    )
                }
            )
        }
    }
}
