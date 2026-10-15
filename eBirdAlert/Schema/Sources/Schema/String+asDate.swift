// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation

public extension String {
    func asDate(in timeZone: TimeZone) -> Date? {
        let f = DateFormatter()
        f.timeZone = timeZone
        f.locale = Locale(identifier: "en_US_POSIX")

        // Most have HH:mm
        f.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = f.date(from: self) {
            return date
        }

        // Some are just the date
        f.dateFormat = "yyyy-MM-dd"
        if let date = f.date(from: self) {
            return date
        }

        // Oh well.
        return nil
    }
}
