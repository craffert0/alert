// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

struct DebugView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DebugLine.ts, order: .reverse)
    private var lines: [DebugLine]
    @State private var now = TimeDataSource<Date>.currentDate

    var body: some View {
        VStack {
            HStack {
                Button("Add", systemImage: "plus") {
                    modelContext.insert(DebugLine(text: "some text"))
                }
                Button("Clear", systemImage: "xmark") {
                    for line in lines {
                        modelContext.delete(line)
                    }
                }
            }
            List(lines) { line in
                HStack {
                    Text(line.ts, relativeTo: now)
                    Text(line.text)
                }
            }
            ChecklistsView()
        }
    }

    func removeLines(at indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(lines[index])
        }
    }
}

#Preview {
    VStack {
        DebugView()
    }
}
