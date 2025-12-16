// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Testing

@Suite struct SetTest {
    @Test func basic() {
        let x = Set<String>()
        let x1 = Set<String>(["one"])
        let x12 = Set<String>(["one", "two"])
        let x123 = Set<String>(["one", "two", "three"])

        #expect(Set<String>(rawValue: x.rawValue) == x)
        #expect(Set<String>(rawValue: x1.rawValue) == x1)
        #expect(Set<String>(rawValue: x12.rawValue) == x12)
        #expect(Set<String>(rawValue: x123.rawValue) == x123)

        #expect(Set<String>(rawValue: "") == x)
        #expect(Set<String>(rawValue: "one") == x1)
        #expect(Set<String>(rawValue: "one|two") == x12)
        #expect(Set<String>(rawValue: "one|two|three") == x123)
    }
}
