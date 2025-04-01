// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

struct BirdObservations {
    let speciesCode: String
    let comName: String
    let sciName: String
    let latestSighting: Date
    let observations: [eBirdObservation]

    init(speciesCode: String,
         comName: String,
         sciName: String,
         observations: [eBirdObservation])
    {
        self.speciesCode = speciesCode
        self.comName = comName
        self.sciName = sciName
        self.observations = observations
        var latest = observations.first!.obsDt
        for o in observations {
            if o.obsDt > latest {
                latest = o.obsDt
            }
        }
        latestSighting = latest
    }
}

extension BirdObservations: Identifiable {
    var id: String { speciesCode }
}

extension BirdObservations: Species {}
