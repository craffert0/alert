// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

extension Set<String>: @retroactive RawRepresentable {
    public typealias RawValue = String

    public init?(rawValue: String) {
        self.init(rawValue.split(separator: "|").map { String($0) })
    }

    public var rawValue: String {
        reduce("") { $0.isEmpty ? $1 : "\($0)|\($1)" }
    }
}
