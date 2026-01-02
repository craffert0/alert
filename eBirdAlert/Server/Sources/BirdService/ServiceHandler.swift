// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI

extension Components.Schemas.Range {
    func dump() {
        switch self {
        case let .RegionCode(code):
            print("region: \(code)")
        case let .Circle(c):
            print("\(c.location.lat), \(c.location.lng): \(c.radius) \(c.units.rawValue)")
        }
    }
}

struct ServiceHandler: APIProtocol {
    func postNotableQuery(_ input: Operations.PostNotableQuery.Input) async throws
        -> Operations.PostNotableQuery.Output
    {
        // TODO: do something with this!
        switch input.body {
        case let .json(q):
            print("\(q.userToken)/\(q.deviceId)")
            print("\(q.daysBack) day(s) back")
            q.range.dump()
            print(q.results.joined(separator: ", "))
        }
        return .accepted
    }

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
