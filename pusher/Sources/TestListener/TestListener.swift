// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import ArgumentParser
import FlyingFox

struct ExampleHandler: HTTPHandler {
    func handleRequest(_: HTTPRequest) async throws -> HTTPResponse {
        HTTPResponse(statusCode: .ok,
                     headers: [.contentType: "text/plain; charset=UTF-8"],
                     body: "yo!".data(using: .utf8)!)
    }
}

@main
struct TestListener: AsyncParsableCommand {
    @Option var port: UInt16

    func run() async throws {
        let server = HTTPServer(port: port)
        await server.appendRoute("GET /api/v1/hello") { _ in
            HTTPResponse(statusCode: .ok,
                         headers: [.contentType: "text/plain; charset=UTF-8"],
                         body: "hello, world".data(using: .utf8)!)
        }
        await server.appendRoute("GET /admin/yo", to: ExampleHandler())
        let task = Task { try await server.run() }
        try await server.waitUntilListening()
        print("listening")
        try await task.value
    }
}
