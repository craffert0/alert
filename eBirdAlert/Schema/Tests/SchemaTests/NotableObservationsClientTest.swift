// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

extension eBirdObservation {
    var json: String {
        get throws {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)!
        }
    }
}

@Suite struct NotableObservationsClientTest {
    let service = eBirdServiceFake(notableName: "20250402T1030")

    var raw_observations: [eBirdObservation] {
        get async throws {
            try await service.getNotable(in: .region(.kings), back: 2)
        }
    }

    @Test func noMismatchForIds() async throws {
        let os = try await raw_observations
        var m: [String: [eBirdObservation]] = [:]
        for o in os {
            m[o.id] = (m[o.id] ?? []) + [o]
        }
        for (_, v) in m {
            let first = try v.first!.json
            for o in v {
                #expect(try first == o.json)
            }
        }
    }

    @Test func raw_parse() async throws {
        let observations = try await raw_observations
        try #require(observations.count == 182)
        let o = observations.first!
        #expect(o.speciesCode == "louwat")
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd hh:mm"
        #expect(o.obsDt == f.date(from: "2025-04-01 18:30"))
    }

    @Test func removed_duplicates_parse() async throws {
        let client = NotableObservationsClient(service: service)
        #expect(try await client.observations(in: .region(.kings), back: 2).count < raw_observations.count)
    }
}
