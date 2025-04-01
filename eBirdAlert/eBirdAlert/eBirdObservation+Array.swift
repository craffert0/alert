// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

extension [eBirdObservation] {
    func collate() -> [BirdObservations] {
        var map: [String: [eBirdObservation]] = [:]
        for o in self {
            if let a = map[o.speciesCode] {
                map[o.speciesCode] = a + [o]
            } else {
                map[o.speciesCode] = [o]
            }
        }
        return map.keys.map { k in
            let v = map[k]!
            return BirdObservations(speciesCode: k,
                                    comName: v.first!.comName,
                                    sciName: v.first!.sciName,
                                    observations: v)
        }.sorted { $0.latestSighting > $1.latestSighting }
    }
}
