// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Testing

@Suite struct ArrayTest {
    @Test func notificationFormatTest() {
        #expect(["one"].notificationFormat == "one")
        #expect(["one", "two"].notificationFormat == "one, two")
        #expect(["one", "two", "three"].notificationFormat == "one, two, three")
        #expect(["one", "two", "three", "four"].notificationFormat == "one, two, three, four")
    }
}
