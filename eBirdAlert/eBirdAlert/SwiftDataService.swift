// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import SwiftData

// https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches

class SwiftDataService {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = SwiftDataService()

    @MainActor
    private init() {
        let schema = Schema([
            Checklist.self,
        ])
        let modelConfiguration =
            ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        modelContainer =
            try! ModelContainer(for: schema,
                                configurations: [modelConfiguration])
        modelContext = modelContainer.mainContext
    }

    @MainActor
    var checklists: [Checklist] {
        try! modelContext.fetch(FetchDescriptor<Checklist>())
    }

    @MainActor
    func prepare(checklist id: String) {
        if get(checklist: id) == nil {
            print("new checklist: \(id)")
            modelContext.insert(Checklist(for: id, status: .unloaded))
        } else {
            print("have checklist: \(id)")
        }
    }

    @MainActor
    func load(checklist id: String) -> Checklist {
        let c = get(checklist: id) ?? {
            let c = Checklist(for: id, status: .unloaded)
            modelContext.insert(c)
            return c
        }()

        if case .unloaded = c.status {
            print("loading \(id)")
            c.status = .loading(startTime: Date.now)
            Task {
                do {
                    let e = try await URLSession.shared.getChecklist(subId: id)
                    DispatchQueue.main.async {
                        c.status = .value(checklist: e)
                    }
                } catch {
                    let e = error
                    DispatchQueue.main.async {
                        c.status = .error(reason: "\(e)")
                    }
                }
            }
        }
        return c
    }

    private func get(checklist id: String) -> Checklist? {
        try! modelContext.fetch(
            FetchDescriptor<Checklist>(
                predicate: #Predicate { $0.id == id },
                sortBy: []
            )).first
    }
}
