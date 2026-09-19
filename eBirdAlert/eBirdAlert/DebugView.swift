// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct DebugView: View {
    enum Selection: String {
        case debug, checklists, secrets, size
    }

    @State private var selection: Selection?

    var body: some View {
        NavigationSplitView {
            mainView
        } detail: {
            detailView
        }
    }

    var mainView: some View {
        List(Selection.allCases,
             selection: $selection)
        {
            Text($0.rawValue)
        }
    }

    @ViewBuilder
    var detailView: some View {
        if let selection {
            switch selection {
            case .debug:
                DebugLinesView()
            case .checklists:
                ChecklistsView()
            case .secrets:
                SecretPreferencesView()
            case .size:
                SizeDebugView()
            }
        }
    }
}

extension DebugView.Selection: CaseIterable, Identifiable {
    var id: Self { self }
}
