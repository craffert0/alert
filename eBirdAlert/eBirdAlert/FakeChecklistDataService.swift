// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

class FakeChecklistDataService: ChecklistDataService {
    @MainActor
    func prepare(obs _: ChecklistDataServiceObservation) {}

    @MainActor
    func load(obs _: ChecklistDataServiceObservation) -> Checklist {
        Checklist(for: UUID().uuidString,
                  date: Date.now,
                  status: .unloaded)
    }
}
