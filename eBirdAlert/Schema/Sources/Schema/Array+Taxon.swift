// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public extension Array where Element: Decodable {
    static func from(_ url: URL) throws -> [Element] {
        try JSONDecoder().decode([Element].self,
                                 from: Data(contentsOf: url))
    }
}
