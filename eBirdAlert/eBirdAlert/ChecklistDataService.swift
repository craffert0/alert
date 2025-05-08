// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Observation
import Schema

protocol ChecklistDataService: Observable {
    @MainActor
    func prepare(obs: eBirdObservation)

    @MainActor
    func load(obs: eBirdObservation) -> Checklist
}
