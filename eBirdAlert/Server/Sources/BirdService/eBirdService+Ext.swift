// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
import Schema

extension eBirdService {
    func getBirds(in range: Components.Schemas.Range,
                  back daysBack: Int) async throws -> Set<String>
    {
        try await Set(
            getNotable(in: range.model, back: daysBack)
                .map(\.speciesCode))
    }
}
