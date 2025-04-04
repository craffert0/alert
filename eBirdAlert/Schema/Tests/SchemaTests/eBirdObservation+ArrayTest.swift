// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

private func dump(json e: any Encodable) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let data = try encoder.encode(e)
    print(String(data: data, encoding: .utf8)!)
}

@Suite struct eBirdObservation_ArrayTest {
    @Test func collate() async throws {
        let client =
            NotableObservationsClient(
                service: eBirdServiceFake(notableName: "20250402T1030"))
        let raw = try await client.observations
        #expect(raw.count == 88)
        let observations = raw.collate()
        #expect(observations.count == 9)
    }
}
