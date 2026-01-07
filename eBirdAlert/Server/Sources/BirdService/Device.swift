// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
import Fluent
import Foundation

final class Device: Model, @unchecked Sendable {
    static let schema = "devices"

    typealias Range = Components.Schemas.Range

    // Fixed fields
    @ID(key: .id) var id: UUID?
    @Parent(key: "user") var user: User
    @Field(key: "deviceId") var deviceId: String

    // From postNotableQuery
    @Field(key: "registerTime") var registerTime: Date
    @Field(key: "rangeData") var rangeData: Data
    @Field(key: "daysBack") var daysBack: Int
    @Field(key: "deviceResult") var deviceResult: [String]

    // Every N minutes update
    @Field(key: "mostRecentResult") var mostRecentResult: [String]
    @Timestamp(
        key: "mostRecentUpdate",
        on: .update
    ) var mostRecentUpdate: Date?

    var range: Range? {
        get { try? JSONDecoder().decode(Range.self, from: rangeData) }
        set(range) {
            if let range {
                rangeData = try! JSONEncoder().encode(range)
            } else {
                rangeData = Data()
            }
        }
    }

    init() {}
}

extension Device {
    static func from(_ db: Database, deviceId: String) async throws -> Device? {
        try await query(on: db)
            .filter(\.$deviceId == deviceId)
            .first()
    }
}
