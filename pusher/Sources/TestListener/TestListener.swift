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
    @Option var api_port: UInt16
    @Option var admin_port: UInt16

    func run() async throws {
        let api_server = HTTPServer(port: api_port)
        let admin_server = HTTPServer(port: admin_port)
        await api_server.appendRoute("GET /v1/hello") { _ in
            HTTPResponse(statusCode: .ok,
                         headers: [.contentType: "text/plain; charset=UTF-8"],
                         body: "hello, world".data(using: .utf8)!)
        }
        await admin_server.appendRoute("GET /v1/yo", to: ExampleHandler())
        let api_task = Task { try await api_server.run() }
        let admin_task = Task { try await admin_server.run() }
        try await api_server.waitUntilListening()
        try await admin_server.waitUntilListening()
        print("listening")
        try await api_task.value
        try await admin_task.value
    }
}
