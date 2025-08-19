// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct eBirdChecklistView: View {
    @State var checklist: eBirdChecklist

    var body: some View {
        if let comments = checklist.comments {
            Label("general comments", systemImage: "globe.americas")
            Text(comments)
                .textSelection(.enabled)
                .padding()
            Spacer()
        }
    }
}

// #Preview {
//     VStack {
//         eBirdChecklistView()
//     }
// }
