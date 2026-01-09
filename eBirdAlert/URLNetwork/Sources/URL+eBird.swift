// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public extension URL {
    init(eBird speciesCode: String) {
        self.init(string: "eBird://obsDetails?code=" + speciesCode)!
    }
}
