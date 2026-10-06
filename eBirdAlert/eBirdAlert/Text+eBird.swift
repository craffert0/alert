// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import SwiftUI

extension Text {
    init(eBird text: String) {
        self.init(AttributedString(eBird: text))
    }
}
