// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public protocol eBirdRegionService {
    func getSubRegions(of region: RegionCodeProvider,
                       as type: eBirdRegionType) throws -> [eBirdRegion]

    func getInfo(for regionCode: String) throws -> eBirdRegionInfo
}

public extension eBirdRegionService {
    func getInfo(of provider: RegionCodeProvider) throws -> eBirdRegionInfo {
        try getInfo(for: provider.code)
    }
}

public extension eBirdRegionService {
    func getRegions(at location: Coordinate) throws -> [eBirdRegionInfo] {
        try getRegions(location, .world, .world, .custom)
    }

    private func getRegions(_ location: Coordinate,
                            _ region: eBirdRegion,
                            _ info: eBirdRegionInfo,
                            _ type: eBirdRegionType)
        throws -> [eBirdRegionInfo]
    {
        guard region.code != "XX" else { return [] }

        guard let subtype = type.subtype else {
            if info.contains(location: location) {
                return [info]
            } else {
                return []
            }
        }
        let subregions = try getSubRegions(of: region, as: subtype)
        if subregions.isEmpty {
            if info.contains(location: location) {
                return [info]
            } else {
                return []
            }
        }

        var result: [eBirdRegionInfo] = []
        for subregion in subregions {
            let info = try getInfo(of: subregion)
            if info.contains(location: location) {
                result += try getRegions(
                    location, subregion, info, subtype
                )
            }
        }
        return result
    }
}

public extension eBirdRegionService {
    func getRegions(at location: Coordinate,
                    around span: CoordinateSpan) throws
        -> [eBirdRegionInfo]
    {
        try getRegions(location, span, .world, .world, .custom)
    }

    private func getRegions(_ location: Coordinate,
                            _ span: CoordinateSpan,
                            _ region: eBirdRegion,
                            _ info: eBirdRegionInfo,
                            _ type: eBirdRegionType)
        throws -> [eBirdRegionInfo]
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
        let subregions = try getSubRegions(of: region, as: subtype)
        if subregions.isEmpty {
            if info.within(span, around: location) {
                return [info]
            } else {
                return []
            }
        }

        var result: [eBirdRegionInfo] = []
        for subregion in subregions {
            let info = try getInfo(of: subregion)
            if info.touches(span, around: location) {
                result += try getRegions(
                    location, span, subregion, info, subtype
                )
            }
        }
        return result
    }
}

public extension eBirdRegionService {
    func getRegion(at location: Coordinate) throws -> eBirdRegionInfo? {
        let regions = try getRegions(at: location)
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
