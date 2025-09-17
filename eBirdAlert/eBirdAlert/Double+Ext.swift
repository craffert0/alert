// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension Double {
    var reduced: Double { log(self) }
    var expanded: Double { exp(self) }
}
