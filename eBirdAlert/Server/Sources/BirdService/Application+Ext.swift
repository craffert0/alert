// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Vapor

extension Application {
    static func make(config: Config) async throws -> Application {
        let app = try await Vapor.Application.make()
        app.http.server.configuration.address = config.address
        app.databases.use(config.database, as: .sqlite)
        app.migrations.add(CreateUser())
        app.migrations.add(CreateDevice())
        try await app.autoMigrate()
        return app
    }
}
