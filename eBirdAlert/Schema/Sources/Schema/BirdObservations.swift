// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public struct BirdObservations {
    public let speciesCode: String
    public let comName: String
    public let sciName: String
    public let latestSighting: Date
    public let observations: [eBirdObservation]

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
