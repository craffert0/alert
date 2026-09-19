// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct SizeDebugView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State var text: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                TextField("who cares", text: $text).padding()
                Grid {
                    GridRow {
                        Text("Horizontal")
                        Text(horizontalSizeClass?.name ?? "?")
                    }
                    GridRow {
                        Text("Vertical")
                        Text(verticalSizeClass?.name ?? "?")
                    }
                }
            }
        }.navigationBarTitle("Debug Size")
    }
}

private extension UserInterfaceSizeClass {
    var name: String {
        switch self {
        case .compact: "compact"
        case .regular: "regular"
        @unknown default: "unknown"
        }
    }
}

#Preview {
    VStack {
        SizeDebugView()
    }
}
