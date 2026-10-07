// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

extension Int {
    func daysBackString(size: ViewSize) -> String {
        if self == 1 {
            if case .large = size {
                "Past day"
            } else {
                "Today"
            }
        } else {
            if case .large = size {
                "Past \(self) days"
            } else {
                "\(self) days"
            }
        }
    }
}
