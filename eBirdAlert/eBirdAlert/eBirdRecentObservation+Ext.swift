// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema

extension eBirdRecentObservation: @retroactive Identifiable {
    public var id: String { "\(speciesCode).\(locId)" }
}

extension eBirdRecentObservation: ObservationSortable {}

extension eBirdRecentObservation: ChecklistDataServiceObservation {}

extension eBirdRecentObservation: eBirdObservationProtocol {
    var userDisplayName: String { "TODO: better name" }
}
