// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

extension Int {
    var daysBackString: String {
        if self == 1 {
            "Past day"
        } else {
            "Past \(self) days"
        }
    }
}
