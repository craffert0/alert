// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

struct ChecklistsView: View {
    @Query(sort: \Checklist.date, order: .reverse) var checklists: [Checklist]

    var body: some View {
        NavigationView {
            List {
                ForEach(checklists) { c in
                    switch c.status {
                    case .unloaded:
                        HStack {
                            Text("\(c.date.relative()) \(c.id)")
                            Text("unloaded")
                        }
                    case let .loading(startTime):
                        HStack {
                            Text("\(c.date.relative()) \(c.id)")
                            Text("loading \(startTime.relative())")
                        }
                    case let .value(checklist):
                        NavigationLink {
                            ChecklistView(checklist: checklist)
                        } label: {
                            Text("\(c.date.relative()) \(c.id)")
                        }
                    case let .error(reason):
                        HStack {
                            Text("\(c.date.relative()) \(c.id)")
                            Text("error: \(reason)")
                        }
                    }
                }
            }
        }
    }
}
