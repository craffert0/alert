// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation

public protocol eBirdRegionService {
    func getSubRegions(of region: RegionCodeProvider,
                       as type: eBirdRegionType) async throws -> [eBirdRegion]
    func getInfo(of regionCode: RegionCodeProvider) async throws -> eBirdRegionInfo
}

public extension eBirdRegionService {
    func getRegions(near location: CLLocation) async throws -> [eBirdRegion] {
        try await getRegions(location, .world, .custom)
    }

    private func getRegions(_ location: CLLocation,
                            _ region: eBirdRegion,
                            _ type: eBirdRegionType)
        async throws -> [eBirdRegion]
    {
        guard let subtype = type.subtype else {
            return [region]
        }
        var result: [eBirdRegion] = []
        for subregion in try await getSubRegions(of: region, as: subtype) {
            let info = try await getInfo(of: subregion)
            if info.contains(location) {
                result += try await getRegions(
                    location, subregion, subtype
                )
            }
        }
        return result
    }
}
