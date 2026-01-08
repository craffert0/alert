// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

protocol DevicesProvider: Sendable {
    func getAll() async throws -> [Device]
    func update(device: Device) async throws
}
