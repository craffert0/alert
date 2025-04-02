// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

struct Wrapper: Codable {
    let date: Date
}

@Suite struct JSONDecoder_DateDecodingStrategyTest {
    func parse(_ s: String) throws -> Date {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .eBirdStyle
        return try d.decode(Wrapper.self,
                            from: Data("{\"date\": \"\(s)\"}".utf8))
            .date
    }

    @Test func test() throws {
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
            let expected = f.date(from: d)!
            let actual = try parse(d)
            #expect(actual == expected)
        }
    }
}
