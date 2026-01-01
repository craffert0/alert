// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import OpenAPIVapor
import Vapor

@main
struct Main {
    static func main() async throws {
        let app = try await Vapor.Application.make()
        app.http.server.configuration.address =
            .hostname("0.0.0.0", port: 8192)
        let transport = VaporTransport(routesBuilder: app)
        let handler = ServiceHandler()
        try handler.registerHandlers(on: transport,
                                     serverURL: Servers.Server1.url())
        try await app.execute()
    }
}
