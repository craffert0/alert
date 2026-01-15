// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation

extension Data {
    var hex: String { map { String(format: "%02.2hhx", $0) }.joined() }
}
