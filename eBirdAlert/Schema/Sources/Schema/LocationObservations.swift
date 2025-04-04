// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public struct LocationObservations: Encodable {
    public var locId: String { observations.first!.locId }
    public var locName: String { observations.first!.locName }
    public var lat: Double { observations.first!.lat }
    public var lng: Double { observations.first!.lng }
    public var speciesCode: String { observations.first!.speciesCode }
    public var latestSighting: Date { observations.first!.obsDt }
    public let observations: [eBirdObservation]
}
