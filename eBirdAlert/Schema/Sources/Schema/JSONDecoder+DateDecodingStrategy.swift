// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public extension JSONDecoder.DateDecodingStrategy {
    static let eBirdStyle = custom { d in
        let raw = try d.singleValueContainer().decode(String.self)
        let f = DateFormatter()
        f.timeZone = TimeZone.current
        f.locale = Locale(identifier: "en_US_POSIX")

        // Most have HH:mm
        f.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = f.date(from: raw) {
            return date
        }

        // Some are just the date
        f.dateFormat = "yyyy-MM-dd"
        if let date = f.date(from: raw) {
            return date
        }

        // Oh well.
        throw DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: d.codingPath,
                                  debugDescription: raw))
    }
}
