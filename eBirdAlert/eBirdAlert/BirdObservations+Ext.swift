// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension BirdObservations: @retroactive Identifiable {
    public var id: String { speciesCode }
}

extension BirdObservations: ObservationSortable {
    public var obsDt: Date { latestSighting }
}
