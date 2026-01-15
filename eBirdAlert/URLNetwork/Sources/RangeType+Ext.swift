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
    private func queryItems(back daysBack: Int? = nil,
                            and item: URLQueryItem? = nil) -> [URLQueryItem]
    {
        var items = [
            URLQueryItem(name: "detail", value: "full"),
            URLQueryItem(name: "hotspot", value: "false"),
        ]
        if let daysBack {
            items += [URLQueryItem(name: "back", value: "\(daysBack)")]
        }
        if let item {
            items += [item]
        }
        return items
    }

    func notableRequest(back daysBack: Int) -> URLRequest {
        switch self {
        case let .region(region):
            URLRequest(
                eBirdPath: "data/obs/\(region.code)/recent/notable",
                queryItems: queryItems(back: daysBack)
            )

        case let .radius(circle):
            URLRequest(
                eBirdPath: "data/obs/geo/recent/notable",
                queryItems: queryItems(back: daysBack, and: circle.queryItem),
                withLocation: circle.location
            )
        }
    }

    func allRequest(back daysBack: Int) -> URLRequest {
        switch self {
        case let .region(region):
            URLRequest(
                eBirdPath: "data/obs/\(region.code)/recent",
                queryItems: queryItems(back: daysBack)
            )

        case let .radius(circle):
            URLRequest(
                eBirdPath: "data/obs/geo/recent",
                queryItems: queryItems(back: daysBack, and: circle.queryItem),
                withLocation: circle.location
            )
        }
    }

    func birdRequest(back daysBack: Int,
                     for speciesCode: String) -> URLRequest
    {
        switch self {
        case let .region(region):
            URLRequest(
                eBirdPath: "data/obs/\(region.code)/recent/\(speciesCode)",
                queryItems: queryItems(back: daysBack)
            )
        case let .radius(circle):
            URLRequest(
                eBirdPath: "data/obs/geo/recent/\(speciesCode)",
                queryItems: queryItems(back: daysBack, and: circle.queryItem),
                withLocation: circle.location
            )
        }
    }
}
