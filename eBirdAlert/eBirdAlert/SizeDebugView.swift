// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct SizeDebugView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State var text: String = ""

    var body: some View {
        GeometryReader { geometry in
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

                        GridRow {
                            Text("Screen Width")
                            Text("\(Int(UIScreen.main.bounds.width))")
                        }
                        GridRow {
                            Text("Screen Height")
                            Text("\(Int(UIScreen.main.bounds.height))")
                        }
                        GridRow {
                            Text("Window Width")
                            Text("\(Int(geometry.size.width))")
                        }
                        GridRow {
                            Text("Window Height")
                            Text("\(Int(geometry.size.height))")
                        }
                    }
                }
            }.navigationBarTitle("Debug Size")
        }
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
