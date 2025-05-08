// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension FormatStyle where Self == FloatingPointFormatStyle<Double> {
    static var eBirdFormat: FloatingPointFormatStyle<Double> {
        FloatingPointFormatStyle<Double>.number
            .rounded(rule: .toNearestOrAwayFromZero,
                     increment: 0.1)
    }
}
