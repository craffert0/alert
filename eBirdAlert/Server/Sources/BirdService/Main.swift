// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
import OpenAPIVapor
import Schema
import URLNetwork
import Vapor

@main
struct Main {
    static func main() async throws {
        // Set up all the protocols.
        let config = Config.global
        let application = try await Vapor.Application.make(config: config)
        let modelProvider: ModelProvider = application
        let birdService: eBirdService = URLSession.shared
        let notificationService = config.notificationService

        // Hook together the objects.
        let runner = DevicesRunner(provider: modelProvider,
                                   birdService: birdService,
                                   notificationService: notificationService,
                                   logger: application.logger)
        let handler = ServiceHandler(provider: modelProvider,
                                     runner: runner,
                                     notificationService: notificationService,
                                     logger: application.logger)
        let transport = VaporTransport(routesBuilder: application)
        try handler.registerHandlers(on: transport,
                                     serverURL: Servers.Server1.url())

        // Schedule our runner, and run it once.
        Timer.scheduledTimer(
            withTimeInterval: config.checkTimeInterval,
            repeats: true
        ) { _ in
            Task { try await runner.run() }
        }.fire()

        // And away we go!
        try await application.execute()
    }
}
