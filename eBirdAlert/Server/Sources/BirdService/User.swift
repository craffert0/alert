// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Fluent
import Foundation

final class User: Model, @unchecked Sendable {
    static let schema = "users"

    @ID(key: .id) var id: UUID?
    @Field(key: "name") var name: String
    @Field(key: "token") var token: String
    @Children(for: \.$user) var devices: [Device]

    init() {}
}

extension User {
    static func from(_ db: Database, name: String) async throws -> User? {
        try await query(on: db)
            .filter(\.$name == name)
            .first()
    }

    static func from(_ db: Database, token: String) async throws -> User? {
        try await query(on: db)
            .filter(\.$token == token)
            .first()
    }
}
