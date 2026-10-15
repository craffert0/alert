// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public extension JSONDecoder.DateDecodingStrategy {
    static let eBirdStyle = custom { d in
        let raw = try d.singleValueContainer().decode(String.self)
        guard let date = raw.asDate(in: .current) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: d.codingPath,
                                      debugDescription: raw)
            )
        }
        return date
    }
}
