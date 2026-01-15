// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension [String] {
    var fakes: [eBirdObservation] { self.map { eBirdObservation(fake: $0) } }
}
