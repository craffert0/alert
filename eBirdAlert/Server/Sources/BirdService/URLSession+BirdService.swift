// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
import Foundation

extension URLSession: BirdService {
    func getBirds(in range: Components.Schemas.Range) async throws
        -> [String]
    {
        // TODO: do it!
        print(range == .RegionCode("foo"))
        return []
    }
}
