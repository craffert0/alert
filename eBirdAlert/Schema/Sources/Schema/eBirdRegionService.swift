// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation

public protocol eBirdRegionService {
    func getSubRegions(of region: RegionCodeProvider,
                       as type: eBirdRegionType) async throws -> [eBirdRegion]
    func getInfo(for regionCode: String) async throws -> eBirdRegionInfo
}

public extension eBirdRegionService {
    func getInfo(of provider: RegionCodeProvider) async throws
        -> eBirdRegionInfo
    {
        try await getInfo(for: provider.code)
    }

    func getRegions(near location: CLLocation) async throws -> [eBirdRegionInfo] {
        try await getRegions(location, .world, .world, .custom)
    }

    private func getRegions(_ location: CLLocation,
                            _ region: eBirdRegion,
                            _ info: eBirdRegionInfo,
                            _ type: eBirdRegionType)
        async throws -> [eBirdRegionInfo]
    {
        guard let subtype = type.subtype else {
            return [info]
        }
        var result: [eBirdRegionInfo] = []
        for subregion in try await getSubRegions(of: region, as: subtype) {
            let info = try await getInfo(of: subregion)
            if info.contains(location) {
                result += try await getRegions(
                    location, subregion, info, subtype
                )
            }
        }
        return result
    }
}
