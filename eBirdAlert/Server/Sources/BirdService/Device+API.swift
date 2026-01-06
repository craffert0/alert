// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
import FluentKit

extension Device {
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
        deviceResult = query.results
        mostRecentResult = query.results
    }
}
