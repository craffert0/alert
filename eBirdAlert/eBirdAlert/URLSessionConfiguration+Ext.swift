// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension URLSessionConfiguration {
    static let cached = {
        var d = URLSessionConfiguration.default
        d.requestCachePolicy = .returnCacheDataElseLoad
        return d
    }()
}
