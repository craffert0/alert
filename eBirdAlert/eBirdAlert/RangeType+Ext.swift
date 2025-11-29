// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

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
                    URLQueryItem(name: "dist", value: "\(circle.units.asKilometers(circle.radius))"),
                ],
                withLocation: circle.location
            )
        }
    }
}
