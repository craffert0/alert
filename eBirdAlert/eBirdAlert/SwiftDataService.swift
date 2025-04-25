// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import SwiftData

// https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches

@Observable
class SwiftDataService {
    private let modelContext: ModelContext

    @MainActor
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    @MainActor
    func prepare(obs: eBirdObservation) {
        guard get(checklist: obs.subId) == nil else {
            return
        }
        modelContext.insert(Checklist(for: obs.subId, date: obs.obsDt,
                                      status: .unloaded))
    }

    @MainActor
    func load(obs: eBirdObservation) -> Checklist {
        let c = get(checklist: obs.subId) ?? {
            let c =
                Checklist(for: obs.subId, date: obs.obsDt, status: .unloaded)
            modelContext.insert(c)
            return c
        }()
        c.load()
        return c
    }

    func garbageCollect(daysBack: Int) {
        if let date = Calendar.current.date(byAdding: .day,
                                            value: -daysBack,
                                            to: Date.now)
        {
            try? modelContext.delete(
                model: Checklist.self,
                where: #Predicate { $0.date <= date }
            )
        }
    }

    private func get(checklist id: String) -> Checklist? {
        try? modelContext.fetch(
            FetchDescriptor<Checklist>(
                predicate: #Predicate { $0.id == id },
                sortBy: []
            )).first
    }
}
