// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI

protocol BirdService: Sendable {
    func getBirds(in range: Components.Schemas.Range) async throws -> [String]
}
