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

extension Device {
    func dump() {
        print($user.name)
        print(registerTime)
        print(daysBack)
        print(deviceResult.joined(separator: ", "))
        print(mostRecentResult.joined(separator: ", "))
        print(String(describing: mostRecentUpdate))
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
        } catch {
            print(error)
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

    func postNotableQuery(
        _ input: Operations.PostNotableQuery.Input
    ) async throws
        -> Operations.PostNotableQuery.Output
    {
        guard case let .json(q) = input.body else { return .unauthorized }

        if let device = try await Device.from(app.db, deviceId: q.deviceId) {
            try await device.$user.load(on: app.db)
            guard device.$user.value?.token == q.userToken else {
                return .unauthorized
            }
            try await device.update(from: q, on: app.db)
            device.dump()
            return .accepted
        }

        guard let user = try await User.from(app.db, token: q.userToken) else {
            print("no user")
            return .unauthorized
        }
        print("create d")
        let device = Device(from: q)
        try await user.$devices.create(device, on: app.db)
        device.dump()
        return .accepted
    }
}
