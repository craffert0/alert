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

extension FormatStyle where Self == Date.FormatStyle {
    static var eBirdFormat: Date.FormatStyle {
        Date.FormatStyle()
            .month(.abbreviated)
            .day(.defaultDigits)
            .hour(.conversationalDefaultDigits(amPM: .abbreviated))
            .minute()
    }

    static var timeOnlyFormat: Date.FormatStyle {
        Date.FormatStyle()
            .hour(.conversationalDefaultDigits(amPM: .abbreviated))
            .minute()
    }
}
