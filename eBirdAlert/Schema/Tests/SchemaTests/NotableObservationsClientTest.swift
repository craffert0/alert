// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

@Suite struct NotableObservationsClientTest {
    @Test func basic() async throws {
        let service = eBirdServiceFake(notableName: "20250402T1030")
        let client = NotableObservationsClient(service: service)
        let observations = try await client.observations
        try #require(observations.count == 183)
        let o = observations.first!
        #expect(o.speciesCode == "louwat")
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd hh:mm"
        #expect(o.obsDt == f.date(from: "2025-04-01 18:30"))
    }
}
