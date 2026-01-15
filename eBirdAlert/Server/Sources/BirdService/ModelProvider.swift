// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

protocol ModelProvider: Sendable {
    func getDevices() async throws -> [Device]
    func getDevice(deviceId: String) async throws -> Device?
    func update(device: Device) async throws
    func create(user: User) async throws
    func create(device: Device, for user: User) async throws
    func getUsers() async throws -> [User]
    func getUser(name: String) async throws -> User?
    func getUser(token: String) async throws -> User?
}
