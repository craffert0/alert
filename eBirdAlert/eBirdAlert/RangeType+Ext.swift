// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension RangeType: @retroactive Equatable {
    public static func == (lhs: RangeType, rhs: RangeType) -> Bool {
        switch (lhs, rhs) {
        case let (.region(a), .region(b)):
            a.code == b.code
        case let (.radius(a), .radius(b)):
            a.location == b.location &&
                a.radius == b.radius &&
                a.units == b.units
        default:
            false
        }
    }
}

extension RangeType {
    var notableRequest: URLRequest {
        switch self {
        case let .region(region):
            URLRequest(
                eBirdPath: "data/obs/\(region.code)/recent/notable",
                queryItems: PreferencesModel.global.queryItems
            )

        case let .radius(circle):
            URLRequest(
                eBirdPath: "data/obs/geo/recent/notable",
                queryItems: PreferencesModel.global.queryItems + [
                    circle.queryItem,
                ],
                withLocation: circle.location
            )
        }
    }

    var allRequest: URLRequest {
        switch self {
        case let .region(region):
            URLRequest(
                eBirdPath: "data/obs/\(region.code)/recent",
                queryItems: PreferencesModel.global.queryItems
            )

        case let .radius(circle):
            URLRequest(
                eBirdPath: "data/obs/geo/recent",
                queryItems: PreferencesModel.global.queryItems + [
                    circle.queryItem,
                ],
                withLocation: circle.location
            )
        }
    }

    func birdRequest(for speciesCode: String) -> URLRequest {
        switch self {
        case let .region(region):
            URLRequest(
                eBirdPath: "data/obs/\(region.code)/recent/\(speciesCode)",
                queryItems: PreferencesModel.global.queryItems
            )
        case let .radius(circle):
            URLRequest(
                eBirdPath: "data/obs/geo/recent/\(speciesCode)",
                queryItems: PreferencesModel.global.queryItems + [
                    circle.queryItem,
                ],
                withLocation: circle.location
            )
        }
    }
}
