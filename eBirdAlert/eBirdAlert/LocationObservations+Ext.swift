// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema

extension LocationObservations: @retroactive Identifiable {
    public var id: String { locId }
}

extension LocationObservations: @retroactive Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension LocationObservations: LocationProtocol {
    var hotspotId: String? {
        observations.first!.hotspotId
    }
}
