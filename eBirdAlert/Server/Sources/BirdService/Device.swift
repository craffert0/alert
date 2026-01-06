// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Fluent
import Foundation

final class Device: Model, @unchecked Sendable {
    static let schema = "devices"

    // Fixed fields
    @ID(key: .id) var id: UUID?
    @Parent(key: "user") var user: User
    @Field(key: "deviceId") var deviceId: String

    // From postNotableQuery
    @Field(key: "registerTime") var registerTime: Date
    // TODO: range
    @Field(key: "daysBack") var daysBack: Int
    @Field(key: "deviceResult") var deviceResult: [String]

    // Every N minutes update
    @Field(key: "mostRecentResult") var mostRecentResult: [String]
    @Timestamp(
        key: "mostRecentUpdate",
        on: .update
    ) var mostRecentUpdate: Date?

    init() {}
}

extension Device {
    static func from(_ db: Database, deviceId: String) async throws -> Device? {
        try await query(on: db)
            .filter(\.$deviceId == deviceId)
            .first()
    }
}
