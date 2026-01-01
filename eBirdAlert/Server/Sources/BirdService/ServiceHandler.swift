// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI

struct ServiceHandler: APIProtocol {
    func getYo(_: Operations.GetYo.Input) async throws
        -> Operations.GetYo.Output
    {
        // this is: Components.Schemas.Yo(message: "Yo!")
        .ok(.init(body: .json(.init(message: "Yo!"))))
    }

    func getHello(_: Operations.GetHello.Input) async throws
        -> Operations.GetHello.Output
    {
        .ok(.init(body: .json(.init(message: "hello, world"))))
    }
}
