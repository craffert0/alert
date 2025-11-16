// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public struct eBirdRegion: Codable, Sendable {
    public let code: String
    public let name: String
}

public extension eBirdRegion {
    static let world = eBirdRegion(code: "world", name: "World")
}

extension eBirdRegion: Identifiable {
    public var id: String { code }
}

extension eBirdRegion: Comparable {
    public static func < (_ a: eBirdRegion, _ b: eBirdRegion) -> Bool {
        a.code < b.code
    }
}

// {
//     "code": "US-NY-047",
//     "name": "Kings"
// }
