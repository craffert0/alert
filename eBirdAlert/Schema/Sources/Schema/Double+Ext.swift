// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public extension Double {
    static let maxNotableDistance: Double = 250
    static let maxLocalDistance: Double = 50

    var reduced: Double { log(self) }
    var expanded: Double { exp(self) }
}
