// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Vapor

extension Application: DevicesProvider {
    func getAll() async throws -> [Device] {
        try await Device.query(on: db).all()
    }

    func update(device: Device) async throws {
        try await device.update(on: db)
    }
}
