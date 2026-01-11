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
        let config = Config.global
        let application = try await Vapor.Application.make(config: config)
        let modelProvider: ModelProvider = application
        let birdService: eBirdService = URLSession.shared
        let notificationService: NotificationService = config.apnsClient

        let runner = DevicesRunner(provider: modelProvider,
                                   birdService: birdService,
                                   notificationService: notificationService)
        let handler = ServiceHandler(provider: modelProvider,
                                     runner: runner,
                                     notificationService: notificationService)
        let transport = VaporTransport(routesBuilder: application)
        try handler.registerHandlers(on: transport,
                                     serverURL: Servers.Server1.url())

        try await application.execute()
    }
}
