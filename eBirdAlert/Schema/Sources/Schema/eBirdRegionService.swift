// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public protocol eBirdRegionService {
    func getSubRegions(of region: RegionCodeProvider,
                       as type: eBirdRegionType) async throws -> [eBirdRegion]

    func getInfo(for regionCode: String) async throws -> eBirdRegionInfo

    func getCensusTract(for location: Coordinate) async throws -> CensusTract
}

public extension eBirdRegionService {
    func getInfo(of provider: RegionCodeProvider) async throws
        -> eBirdRegionInfo
    {
        try await getInfo(for: provider.code)
    }

    func getRegions(at location: Coordinate,
                    around span: CoordinateSpan) async throws
        -> [eBirdRegionInfo]
    {
        try await getRegions(location, span, .world, .world, .custom)
    }

    private func getRegions(_ location: Coordinate,
                            _ span: CoordinateSpan,
                            _ region: eBirdRegion,
                            _ info: eBirdRegionInfo,
                            _ type: eBirdRegionType)
        async throws -> [eBirdRegionInfo]
    {
        if region.code == "XX" {
            return []
        }
        guard let subtype = type.subtype else {
            if info.within(span, around: location) {
                return [info]
            } else {
                return []
            }
        }
        let subregions = try await getSubRegions(of: region, as: subtype)
        if subregions.isEmpty {
            if info.within(span, around: location) {
                return [info]
            } else {
                return []
            }
        }

        var result: [eBirdRegionInfo] = []
        for subregion in subregions {
            let info = try await getInfo(of: subregion)
            if info.touches(span, around: location) {
                result += try await getRegions(
                    location, span, subregion, info, subtype
                )
            }
        }
        return result
    }
}
