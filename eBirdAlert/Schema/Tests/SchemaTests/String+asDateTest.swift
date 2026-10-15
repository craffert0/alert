// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

struct String_asDateTest {
    @Test func full() throws {
        let dates = [
            "2025-03-05 16:04",
            "2025-03-20 15:58",
            "2025-03-20 15:59",
        ]
        for d in dates {
            let f = DateFormatter()
            f.timeZone = TimeZone.current
            f.locale = Locale(identifier: "en_US_POSIX")
            f.dateFormat = "yyyy-MM-dd HH:mm"
            let expected = try #require(f.date(from: d))
            let actual = try #require(d.asDate(in: .current))
            #expect(actual == expected)
        }
    }

    @Test func days() throws {
        let dates = [
            "2025-03-05",
            "2025-03-20",
        ]
        for d in dates {
            let f = DateFormatter()
            f.timeZone = TimeZone.current
            f.locale = Locale(identifier: "en_US_POSIX")
            f.dateFormat = "yyyy-MM-dd"
            let expected = try #require(f.date(from: d))
            let actual = try #require(d.asDate(in: .current))
            #expect(actual == expected)
        }
    }
}
