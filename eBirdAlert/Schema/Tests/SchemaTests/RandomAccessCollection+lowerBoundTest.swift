// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import Testing

extension [Int] {
    func lowerBound(for value: Int) -> Index {
        lowerBound(where: { $0 < value })
    }
}

@Suite struct RandomAccessCollection_LowerBoundTest {
    @Test func none() {
        let haystack: [Int] = []
        #expect(haystack.lowerBound(for: 3) == haystack.endIndex)
    }

    @Test func all() {
        let haystack = [1, 3, 5, 7, 9]
        var expected = haystack.startIndex
        for i in 0 ... 5 {
            #expect(haystack.lowerBound(for: i * 2) == expected)
            #expect(haystack.lowerBound(for: i * 2 + 1) == expected)
            if i != 5 {
                #expect(haystack[expected] == i * 2 + 1)
            }
            expected = haystack.index(expected, offsetBy: 1)
        }
    }
}
