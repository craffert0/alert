// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
import FluentKit

extension Device {
    var api: Components.Schemas.Device {
        Components.Schemas.Device(
            user: $user.value?.name,
            deviceId: deviceId,
            deviceType: deviceType,
            registerTime: registerTime.formatted(.iso8601),
            range: range,
            daysBack: daysBack,
            deviceSpecies: deviceSpecies,
            mostRecentPushSpecies: mostRecentPushSpecies,
            mostRecentUpdate: mostRecentUpdate?.formatted(.iso8601)
        )
    }

    convenience init(from query: Components.Schemas.NotableQuery) {
        self.init()
        deviceId = query.deviceId
        update(from: query)
    }

    func update(from query: Components.Schemas.NotableQuery) {
        deviceId = query.deviceId
        deviceType = query.deviceType ?? .production
        registerTime = .now
        daysBack = query.daysBack
        range = query.range
        deviceSpecies = query.results
        mostRecentPushSpecies = []
    }
}
