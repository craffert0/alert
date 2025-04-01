// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public extension JSONDecoder.DateDecodingStrategy {
    static let eBirdStyle = custom { d in
        let raw = try d.singleValueContainer().decode(String.self)
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.formatOptions =
            [.withFullDate, .withDashSeparatorInDate,
             .withSpaceBetweenDateAndTime, .withTime,
             .withColonSeparatorInTime]
        guard let date = formatter.date(from: raw + ":00") else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: d.codingPath,
                                      debugDescription: raw))
        }
        return date
    }
}
