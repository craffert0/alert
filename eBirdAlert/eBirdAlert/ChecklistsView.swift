// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

struct ChecklistsView: View {
    @Query(sort: \Checklist.date, order: .reverse) var checklists: [Checklist]

    var body: some View {
        NavigationStack {
            List(checklists) { c in
                ChecklistLinkView(checklist: c)
            }
        }
    }
}
