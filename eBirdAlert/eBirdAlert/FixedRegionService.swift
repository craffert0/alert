// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import URLNetwork

class FixedRegionService: eBirdRegionService {
    static let global = FixedRegionService()

    private lazy var loader: FixedRegionLoader = {
        let url = Bundle.main.url(forResource: "regions",
                                  withExtension: "csv")!
        return try! FixedRegionLoader(infos: .fromCSV(url))
    }()

    func getSubRegions(of region: RegionCodeProvider,
                       as _: eBirdRegionType) throws -> [eBirdRegion]
    {
        loader.getSubRegions(of: region)
    }

    func getInfo(for regionCode: String) throws -> eBirdRegionInfo {
        guard let info = loader.getInfo(for: regionCode) else {
            throw eBirdServiceError.noRegion(regionCode: regionCode)
        }
        return info
    }
}
