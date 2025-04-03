// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension TimeInterval {
    var english: String {
        let seconds = Int(self)
        switch seconds {
        case 0 ..< 60: return "\(seconds)s"
        case 60 ..< 3600: return "\(seconds / 60)m"
        case 3600 ..< 86400: return "\(seconds / 3600)h"
        default: return "\(seconds / 86400)d"
        }
    }
}
