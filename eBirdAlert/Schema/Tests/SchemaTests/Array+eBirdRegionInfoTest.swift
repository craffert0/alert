// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

struct ArrayeBirdRegionInfoTest {
    @Test func basic() async throws {
        let url = try #require(Bundle.module.url(forResource: "regions",
                                                 withExtension: "csv"))
        let loader =
            try await FixedRegionLoader(infos: [eBirdRegionInfo].fromCSV(url))
        let us = try #require(loader.getInfo(for: "US"))
        #expect(us.code == "US")
        #expect(us.result == "United States")
        #expect(us.latitude == 45.150272)
        #expect(us.longitude == 0.311425)
        #expect(us.type == .country)
        #expect(us.bounds?.minX == -179.150558)
        #expect(us.bounds?.maxX == 179.773408)
        #expect(us.bounds?.minY == 18.909858)
        #expect(us.bounds?.maxY == 71.390685)
        #expect(us.subregionCodes?.count == 51)

        let xx = try #require(loader.getInfo(for: "XX"))
        #expect(xx.result == "High Seas")
        #expect(xx.bounds == nil)
        #expect(xx.subregionCodes == nil)
    }
}
