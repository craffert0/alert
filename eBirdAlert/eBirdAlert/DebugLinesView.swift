// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

struct DebugLinesView: View {
    @Environment(SwiftDataService.self) private var swiftDataService
    @Query(sort: \DebugLine.ts, order: .reverse)
    private var lines: [DebugLine]
    @State private var now = TimeDataSource<Date>.currentDate

    var body: some View {
        VStack {
            HStack {
                Button("Add", systemImage: "plus") {
                    swiftDataService.addLine(text: "some text!")
                }
                Button("Clear", systemImage: "xmark") {
                    swiftDataService.clearLines()
                }
            }
            List(lines) { line in
                HStack {
                    Text(line.ts, relativeTo: now)
                    Text(line.text)
                }
            }
        }
    }
}
