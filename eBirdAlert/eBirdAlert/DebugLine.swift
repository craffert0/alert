// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

typealias DebugLine = SchemaV1.DebugLine

extension DebugLine {
    convenience init(text: String) {
        self.init(at: Date.now, text: text)
    }
}
