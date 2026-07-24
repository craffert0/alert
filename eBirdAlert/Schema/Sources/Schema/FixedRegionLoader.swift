// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import SwiftUtil

public class FixedRegionLoader {
    private let infos: [eBirdRegionInfo]

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
        let it = infos.lowerBound(of: regionCode, comp: { $0.code < $1 })
        guard it != infos.endIndex, infos[it].code == regionCode else {
            return nil
        }
        return infos[it]
    }
}
