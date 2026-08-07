// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

public struct FakeRegionService: Decodable {
    let subregion: [Subregion]
    let info: [Info]
    let result: [eBirdRegion]

    struct Subregion: Decodable {
        let type: eBirdRegionType
        let region: eBirdRegion
        let result: [eBirdRegion]
    }

    struct Info: Decodable {
        let region: eBirdRegion
        let result: eBirdRegionInfo
    }
}

public extension FakeRegionService {
    static func from(resource: String) throws -> FakeRegionService {
        try JSONDecoder().decode(
            FakeRegionService.self,
            from: Data(contentsOf: Bundle.module.url(forResource: resource,
                                                     withExtension: "json")!)
        )
    }
}

extension FakeRegionService: eBirdRegionService {
    enum ServiceError: Error {
        case noSubregions(String)
        case noInfo
    }

    public func getSubRegions(of region: RegionCodeProvider,
                              as type: eBirdRegionType)
        -> [eBirdRegion]
    {
        for s in subregion {
            if s.region.code == region.code, s.type == type {
                return s.result
            }
        }
        return []
    }

    public func getInfo(for regionCode: String) -> eBirdRegionInfo? {
        for i in info {
            if i.region.code == regionCode {
                return i.result
            }
        }
        return nil
    }
}
