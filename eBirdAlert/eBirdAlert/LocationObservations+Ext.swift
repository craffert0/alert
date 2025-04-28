// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema

extension LocationObservations: @retroactive Identifiable {
    public var id: String { locId }
}

extension LocationObservations: LocationProtocol {}
