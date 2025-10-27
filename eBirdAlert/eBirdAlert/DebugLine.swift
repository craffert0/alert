// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import SwiftData

@Model
final class DebugLine {
    @Attribute(.unique) var ts: Date
    var text: String

    init(at ts: Date,
         text: String)
    {
        self.ts = ts
        self.text = text
    }

    convenience init(text: String) {
        self.init(at: Date.now, text: text)
    }
}
