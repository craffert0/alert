// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import URLNetwork

struct LookupOption {
    let range: RangeValue
    let daysBack: Int

    enum RangeValue {
        case radius(Double, DistanceUnits)
        case region(String?)
    }
}

extension LookupOption.RangeValue: Equatable {}
extension LookupOption: Equatable {}

extension LookupOption {
    func range(for location: Coordinate?,
               with service: eBirdRegionService) throws -> RangeType
    {
        switch range {
        case let .radius(distance, units):
            guard let location else { throw eBirdServiceError.noLocation }
            return .radius(CircleModel(location: location,
                                       radius: distance,
                                       units: units))
        case let .region(regionCode):
            if let regionCode {
                guard let info = service.getInfo(for: regionCode) else {
                    throw eBirdServiceError.noRegion(regionCode: regionCode)
                }
                return .region(info)
            } else {
                guard let location else {
                    throw eBirdServiceError.noLocation
                }
                guard let region = service.getRegion(at: location) else {
                    throw eBirdServiceError.noLocationRegion
                }
                return .region(region)
            }
        }
    }
}

extension LookupOption {
    var expanded: LookupOption? {
        switch range {
        case let .radius(distance, units):
            if distance < .maxNotableDistance {
                .init(range: .radius(min(2 * distance, .maxNotableDistance),
                                     units),
                      daysBack: daysBack)
            } else {
                nil
            }
        case .region:
            nil
        }
    }
}
