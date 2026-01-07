// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
import FluentKit

extension Device {
    var api: Components.Schemas.Device {
        Components.Schemas.Device(user: $user.value?.name,
                                  deviceId: deviceId,
                                  range: range,
                                  daysBack: daysBack,
                                  deviceResult: deviceResult,
                                  mostRecentResult: mostRecentResult)
    }

    convenience init(from query: Components.Schemas.NotableQuery) {
        self.init()
        deviceId = query.deviceId
        update(from: query)
    }

    func update(from query: Components.Schemas.NotableQuery,
                on db: Database) async throws
    {
        update(from: query)
        try await update(on: db)
    }

    private func update(from query: Components.Schemas.NotableQuery) {
        registerTime = .now
        daysBack = query.daysBack
        range = query.range
        deviceResult = query.results
        mostRecentResult = query.results
    }
}

extension [Device] {
    func asApi(on db: Database) async throws -> [Components.Schemas.Device] {
        for d in self {
            try await d.$user.load(on: db)
        }
        return map(\.api)
    }
}
