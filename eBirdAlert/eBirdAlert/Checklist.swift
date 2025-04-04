// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftData

@Model
final class Checklist {
    @Attribute(.unique) var id: String
    var status: ChecklistStatus

    init(for id: String,
         status: ChecklistStatus)
    {
        self.id = id
        self.status = status
    }

    func observation(for obsId: String) -> eBirdChecklist.Obs? {
        guard case let .value(checklist) = status else {
            return nil
        }
        return checklist.obs.first { $0.obsId == obsId }
    }
}
