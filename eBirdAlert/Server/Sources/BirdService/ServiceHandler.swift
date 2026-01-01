// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

struct ServiceHandler: APIProtocol {
    func getYo(_: Operations.getYo.Input) async throws
        -> Operations.getYo.Output
    {
        // this is: Components.Schemas.Yo(message: "Yo!")
        .ok(.init(body: .json(.init(message: "Yo!"))))
    }

    func getHello(_: Operations.getHello.Input) async throws
        -> Operations.getHello.Output
    {
        .ok(.init(body: .plainText("hello, world")))
    }
}
