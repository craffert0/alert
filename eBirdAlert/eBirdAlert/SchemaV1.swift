// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import SwiftData

struct SchemaV1: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [Checklist.self, DebugLine.self]
    }

    static var versionIdentifier: Schema.Version = .init(1, 0, 0)
}

extension SchemaV1 {
    @Model
    final class Checklist {
        @Attribute(.unique) var id: String
        var date: Date
        var status: ChecklistStatus

        init(for id: String,
             date: Date,
             status: ChecklistStatus)
        {
            self.id = id
            self.date = date
            self.status = status
        }
    }
}

extension SchemaV1 {
    @Model
    final class DebugLine {
        @Attribute(.unique) var ts: Date
        var text: String

        init(at ts: Date,
             text: String)
        {
            self.ts = ts
            self.text = text
        }
    }
}
