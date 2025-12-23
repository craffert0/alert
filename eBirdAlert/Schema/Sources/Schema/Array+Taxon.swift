// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public extension [Taxon] {
    static func from(_ url: URL) throws -> [Taxon] {
        try JSONDecoder().decode([Taxon].self,
                                 from: Data(contentsOf: url))
    }
}
