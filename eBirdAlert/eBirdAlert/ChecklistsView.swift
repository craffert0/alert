// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct ChecklistsView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(SwiftDataService.shared.checklists
                    .sorted { $0.date > $1.date })
                { c in
                    switch c.status {
                    case .unloaded:
                        HStack {
                            Text("\(c.date.relative()) \(c.id)")
                            Text("maybe load?")
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
