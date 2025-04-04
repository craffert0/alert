// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public extension [eBirdObservation] {
    func collate() -> [BirdObservations] {
        var map: [String: [eBirdObservation]] = [:]
        for o in self {
            map[o.speciesCode] = (map[o.speciesCode] ?? []) + [o]
        }
        return map.values.map { v in
            BirdObservations(observations: v)
        }.sorted { $0.latestSighting > $1.latestSighting }
    }
}
