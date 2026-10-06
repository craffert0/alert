// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation

public extension CharacterSet {
    static let urlQueryParamAndKeyAllowed: CharacterSet = {
        var result = CharacterSet.urlQueryAllowed
        result.remove(charactersIn: ";/?:@&=+$, ")
        return result
    }()
}
