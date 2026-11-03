// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public nonisolated protocol eBirdRegionService: Sendable {
    func getSubRegions(of region: RegionCodeProvider,
                       as type: eBirdRegionType) async -> [eBirdRegion]

    func getInfo(for regionCode: String) async -> eBirdRegionInfo?
}

public extension eBirdRegionService {
    func getInfo(of provider: RegionCodeProvider) async -> eBirdRegionInfo? {
        await getInfo(for: provider.code)
    }
}

public extension eBirdRegionService {
    // Get a list of lowest regions containing the location.
    @concurrent
    func getRegions(at location: Coordinate) async -> [eBirdRegionInfo] {
        await getRegions(location, .world, .world, .custom)
    }

    private func getRegions(_ location: Coordinate,
                            _ region: eBirdRegion,
                            _ info: eBirdRegionInfo,
                            _ type: eBirdRegionType) async
        -> [eBirdRegionInfo]
    {
        guard region.code != "XX" else { return [] }

        guard let subtype = type.subtype else {
            if info.contains(location: location) {
                return [info]
            } else {
                return []
            }
        }
        let subregions = await getSubRegions(of: region, as: subtype)
        if subregions.isEmpty {
            if info.contains(location: location) {
                return [info]
            } else {
                return []
            }
        }

        var result: [eBirdRegionInfo] = []
        for subregion in subregions {
            if let info = await getInfo(of: subregion),
               info.contains(location: location)
            {
                result += await getRegions(
                    location, subregion, info, subtype
                )
            }
        }
        return result
    }
}

public extension eBirdRegionService {
    // Get a list of lowest regions within the window specified by location &
    // span.
    func getRegions(at location: Coordinate,
                    around span: CoordinateSpan) async
        -> [eBirdRegionInfo]
    {
        await getRegions(location, span, .world, .world, .custom)
    }

    private func getRegions(_ location: Coordinate,
                            _ span: CoordinateSpan,
                            _ region: eBirdRegion,
                            _ info: eBirdRegionInfo,
                            _ type: eBirdRegionType) async
        -> [eBirdRegionInfo]
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
        let subregions = await getSubRegions(of: region, as: subtype)
        if subregions.isEmpty {
            if info.within(span, around: location) {
                return [info]
            } else {
                return []
            }
        }

        var result: [eBirdRegionInfo] = []
        for subregion in subregions {
            if let info = await getInfo(of: subregion),
               info.touches(span, around: location)
            {
                result += await getRegions(
                    location, span, subregion, info, subtype
                )
            }
        }
        return result
    }
}

public extension eBirdRegionService {
    // Get the lowest containing region whose center is closest to the
    // location.
    func getRegion(at location: Coordinate) async -> eBirdRegionInfo? {
        let regions = await getRegions(at: location)
        guard var best = regions.first else { return nil }
        var distance2 = location.distance2(.init(from: best))
        for r in regions {
            let d2 = location.distance2(.init(from: r))
            if d2 < distance2 {
                best = r
                distance2 = d2
            }
        }
        return best
    }
}
