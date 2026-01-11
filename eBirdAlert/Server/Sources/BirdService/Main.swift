// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
import OpenAPIVapor
import URLNetwork
import Vapor

@main
struct Main {
    static func main() async throws {
        let app = try await Vapor.Application.make()
        app.http.server.configuration.address = Config.global.address
        app.databases.use(Config.global.database, as: .sqlite)
        app.migrations.add(CreateUser())
        app.migrations.add(CreateDevice())
        try await app.autoMigrate()
        let transport = VaporTransport(routesBuilder: app)
        let runner = DevicesRunner(provider: app,
                                   birdService: URLSession.shared,
                                   notificationService: URLSession.shared)
        let handler = ServiceHandler(provider: app, runner: runner)
        try handler.registerHandlers(on: transport,
                                     serverURL: Servers.Server1.url())
        try await app.execute()
    }
}
