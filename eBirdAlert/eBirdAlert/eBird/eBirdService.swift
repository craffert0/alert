// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation

class eBirdService {
    var location: CLLocation?

    // data/obs/geo/recent/notable
    func getNearbyNotable(back _: Int? = nil, distKM _: Int = 5,
                          hotspot _: Bool = false, max _: Int? = nil)
        async throws -> [eBirdObservation]
    {
        // TODO: Implement me, duh!
        throw CancellationError()
    }
}
