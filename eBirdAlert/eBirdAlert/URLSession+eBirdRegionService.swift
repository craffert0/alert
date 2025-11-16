// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension URLSession: @retroactive eBirdRegionService {
    public func getSubRegions(
        of region: eBirdRegion,
        as type: eBirdRegionType
    ) async throws -> [Schema.eBirdRegion] {
        let request = try URLRequest(
            eBirdPath: "ref/region/list/\(type)/\(region.code)"
        )
        return try await object(for: request)
    }

    public func getInfo(of region: eBirdRegion)
        async throws -> eBirdRegionInfo
    {
        let request = try URLRequest(
            eBirdPath: "ref/region/info/\(region.code)"
        )
        return try await object(for: request)
    }
}
