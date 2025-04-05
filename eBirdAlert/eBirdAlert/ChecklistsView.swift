// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct ChecklistsView: View {
    var body: some View {
        List {
            ForEach(SwiftDataService.shared.checklists) { c in
                HStack {
                    Text(c.id)
                    switch c.status {
                    case .unloaded:
                        Text("maybe load?")
                    case let .loading(startTime):
                        Text("loading \(startTime.relative())")
                    case .value:
                        Text("checklist")
                    case let .error(reason):
                        Text("error: \(reason)")
                    }
                }
            }
        }
    }
}
