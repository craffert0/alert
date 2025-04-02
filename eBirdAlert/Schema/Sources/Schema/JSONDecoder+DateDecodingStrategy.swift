// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public extension JSONDecoder.DateDecodingStrategy {
    static let eBirdStyle = custom { d in
        let raw = try d.singleValueContainer().decode(String.self)
        let f = DateFormatter()
        f.timeZone = TimeZone.current
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd HH:mm"
        guard let date = f.date(from: raw) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: d.codingPath,
                                      debugDescription: raw))
        }
        return date
    }
}
