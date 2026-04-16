// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema

extension eBirdObservation: LocationProtocol {
    var hotspotId: String? {
        locationPrivate ? nil : locId
    }
}

extension eBirdObservation: ChecklistDataServiceObservation {}

extension eBirdObservation: eBirdObservationProtocol {}
