// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct DebugView: View {
    var body: some View {
        TabView {
            Tab("Debug", systemImage: "text.page") {
                DebugLinesView()
            }
            Tab("Checklists", systemImage: "list.bullet.circle") {
                ChecklistsView()
            }
            Tab("Preferences", systemImage: "flame.circle") {
                SecretPreferencesView()
            }
        }
    }
}
