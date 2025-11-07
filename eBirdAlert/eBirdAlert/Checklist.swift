// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import SwiftData

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

    func observation(for speciesCode: String) -> eBirdChecklist.Obs? {
        guard case let .value(checklist) = status else {
            return nil
        }
        return checklist.obs.first { $0.speciesCode == speciesCode }
    }

    func load() {
        guard case .unloaded = status else { return }
        status = .loading(startTime: Date.now)
        Task {
            do {
                let e = try await URLSession.shared.getChecklist(subId: id)
                Task { @MainActor in
                    self.date = e.obsDt
                    self.status = .value(checklist: e)
                }
            } catch {
                let e = error
                Task { @MainActor in
                    self.status = .error(reason: "\(e)")
                }
            }
        }
    }
}
