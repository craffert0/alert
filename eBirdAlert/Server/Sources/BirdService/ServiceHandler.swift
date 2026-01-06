// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
import FluentKit
import Vapor

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
    let app: Vapor.Application

    func newUser(_ input: Operations.NewUser.Input) async throws
        -> Operations.NewUser.Output
    {
        guard case let .json(req) = input.body else {
            return .conflict // TODO: this should be better
        }
        do {
            let user = User(name: req.name)
            try await user.create(on: app.db)
            return .created(.init(body: .json(user.response)))
        } catch is DatabaseError {
            return .conflict
        }
    }

    func getUser(_ input: Operations.GetUser.Input) async throws
        -> Operations.GetUser.Output
    {
        guard let user = try await User.from(app.db, name: input.query.name)
        else {
            return .notFound
        }
        return .ok(.init(body: .json(user.response)))
    }

    func getUsers(_: Operations.GetUsers.Input) async throws
        -> Operations.GetUsers.Output
    {
        try await .ok(.init(
            body: .json(User.query(on: app.db).all().map(\.response))))
    }

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
}
