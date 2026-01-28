// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Fluent

struct CreateDevice: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(Device.schema)
            .id()
            .field("user", .uuid, .required, .references(User.schema, "id"))
            .field("deviceId", .string, .required)
            .field("deviceType",
                   .enum(.init(name: "deviceType",
                               cases: ["development", "production"])),
                   .required)
            .field("registerTime", .datetime, .required)
            .field("rangeData", .data, .required)
            .field("daysBack", .int8, .required)
            .field("deviceSpecies", .array(of: .string), .required)
            .field("mostRecentPushSpecies", .array(of: .string), .required)
            .field("mostRecentUpdate", .datetime)
            .unique(on: "deviceId")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(User.schema).delete()
    }
}
