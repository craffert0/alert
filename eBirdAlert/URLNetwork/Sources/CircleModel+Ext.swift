// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension CircleModel {
    func queryItem(maxRadius: Double) -> URLQueryItem {
        let radius = min(units.asKilometers(radius), maxRadius)
        return URLQueryItem(name: "dist", value: String(radius))
    }
}
