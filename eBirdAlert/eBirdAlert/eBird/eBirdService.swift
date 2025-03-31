// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

class eBirdService {
    @AppStorage(wrappedValue: "", .settingsApplicationKey)
    private var applicationKey: String

    // data/obs/geo/recent/notable
    func getNearbyNotable(back _: Int? = nil, distKM _: Int = 5,
                          hotspot _: Bool = false, max _: Int? = nil)
        async throws -> [eBirdObservation]
    {
        guard applicationKey != "" else { throw eBirdServiceError.noKey }

        // TODO: Implement me, duh!
        throw CancellationError()
    }
}
