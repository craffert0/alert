// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Vapor

extension Application: ModelProvider {
    func getDevices() async throws -> [Device] {
        let devices = try await Device.query(on: db).all()
        for d in devices {
            try await d.$user.load(on: db)
        }
        return devices
    }

    func getDevice(deviceId: String) async throws -> Device? {
        let device = try await Device.from(db, deviceId: deviceId)
        if let device {
            try await device.$user.load(on: db)
        }
        return device
    }

    func update(device: Device) async throws {
        try await device.update(on: db)
    }

    func create(user: User) async throws {
        try await user.create(on: db)
    }

    func create(device: Device, for user: User) async throws {
        try await user.$devices.create(device, on: db)
    }

    func getUsers() async throws -> [User] {
        try await User.query(on: db).all()
    }

    func getUser(name: String) async throws -> User? {
        try await User.from(db, name: name)
    }

    func getUser(token: String) async throws -> User? {
        try await User.from(db, token: token)
    }
}
