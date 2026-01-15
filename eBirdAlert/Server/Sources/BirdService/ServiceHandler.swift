// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
import Logging

struct ServiceHandler: APIProtocol {
    let provider: ModelProvider
    let runner: DevicesRunner
    let notificationService: NotificationService
    let logger: Logger

    func trigger(_: Operations.Trigger.Input) async throws
        -> Operations.Trigger.Output
    {
        try await runner.run()
        return .accepted
    }

    func newUser(_ input: Operations.NewUser.Input) async throws
        -> Operations.NewUser.Output
    {
        guard case let .json(req) = input.body else {
            return .conflict // TODO: this should be better
        }
        do {
            let user = User(from: req)
            try await provider.create(user: user)
            return .created(.init(body: .json(user.response)))
        } catch {
            logger.info("newUser: \(error)")
            return .conflict
        }
    }

    func getUser(_ input: Operations.GetUser.Input) async throws
        -> Operations.GetUser.Output
    {
        guard let user = try await provider.getUser(name: input.query.name)
        else {
            return .notFound
        }
        return .ok(.init(body: .json(user.response)))
    }

    func getUsers(_: Operations.GetUsers.Input) async throws
        -> Operations.GetUsers.Output
    {
        try await .ok(.init(
            body: .json(provider.getUsers().map(\.response))))
    }

    func getDevices(_: Operations.GetDevices.Input) async throws
        -> Operations.GetDevices.Output
    {
        try await .ok(.init(body:
            .json(provider.getDevices().map(\.api))))
    }

    func postNotableQuery(
        _ input: Operations.PostNotableQuery.Input
    ) async throws
        -> Operations.PostNotableQuery.Output
    {
        guard case let .json(q) = input.body else { return .unauthorized }

        if let device = try await provider.getDevice(deviceId: q.deviceId) {
            guard device.$user.value?.token == q.userToken else {
                return .unauthorized
            }
            device.update(from: q)
            try await provider.update(device: device)
            logger.info(
                "notableQuery: updated \(device.name)"
            )
            return .accepted
        }

        guard let user = try await provider.getUser(token: q.userToken) else {
            logger.info("notableQuery: no user \(q.userToken)")
            return .unauthorized
        }
        let device = Device(from: q)
        try await provider.create(device: device, for: user)
        logger.info(
            "notableQuery: created \(device.name) for \(user.name)"
        )
        return .accepted
    }

    func sendFake(_ input: Operations.SendFake.Input) async throws
        -> Operations.SendFake.Output
    {
        guard case let .json(q) = input.body else { return .notFound }
        try await notificationService.notify(q.deviceId,
                                             newBirds: Set(q.birds),
                                             badgeCount: q.birds.count)
        return .accepted
    }
}
