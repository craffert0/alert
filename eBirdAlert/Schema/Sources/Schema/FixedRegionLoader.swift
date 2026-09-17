// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

public struct FixedRegionLoader {
    public let infos: [eBirdRegionInfo]

    public init(infos: [eBirdRegionInfo]) {
        self.infos = infos
    }

    public func getSubRegions(of region: RegionCodeProvider)
        -> [eBirdRegion]
    {
        (getInfo(for: region.code)?.subregionCodes ?? []).map {
            eBirdRegion(code: $0)
        }
    }

    public func getInfo(for regionCode: String) -> eBirdRegionInfo? {
        infos.getInfo(for: regionCode)
    }
}
