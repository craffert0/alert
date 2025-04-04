// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public struct BirdObservations: Encodable {
    private var rep: eBirdObservation { locations.first!.observations.first! }
    public var speciesCode: String { rep.speciesCode }
    public var comName: String { rep.comName }
    public var sciName: String { rep.sciName }
    public var latestSighting: Date { rep.obsDt }
    public let locations: [LocationObservations]

    init(observations: [eBirdObservation]) {
        var map: [String: [eBirdObservation]] = [:]
        for o in observations {
            map[o.locId] = (map[o.locId] ?? []) + [o]
        }
        locations = map.values.map { v in
            LocationObservations(observations: v.sorted { $0.obsDt > $1.obsDt })
        }.sorted { $0.latestSighting > $1.latestSighting }
    }
}
