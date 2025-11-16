// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation

public protocol eBirdRegionService {
    func getSubRegions(of regionCode: eBirdRegion,
                       as type: eBirdRegionType) async throws -> [eBirdRegion]
    func getInfo(of regionCode: eBirdRegion) async throws -> eBirdRegionInfo
}

public extension eBirdRegionService {
    func getRegions(near location: CLLocation) async throws -> [eBirdRegion] {
        try await getRegions(location, .world, eBirdRegionType.allCases)
    }

    private func getRegions(_ location: CLLocation,
                            _ region: eBirdRegion,
                            _ regionTypes: eBirdRegionType.AllCases)
        async throws -> [eBirdRegion]
    {
        guard let regionType = regionTypes.first else {
            return [region]
        }
        var result: [eBirdRegion] = []
        for subregion in try await getSubRegions(of: region, as: regionType) {
            let info = try await getInfo(of: subregion)
            if info.contains(location) {
                result += try await getRegions(
                    location, subregion,
                    regionTypes.suffix(regionTypes.count - 1)
                )
            }
        }
        return result
    }
}
