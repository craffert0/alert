// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension CircleModel {
    var queryItem: URLQueryItem {
        URLQueryItem(name: "dist",
                     value: "\(units.asKilometers(radius))")
    }
}
