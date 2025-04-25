// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct ChecklistLinkView: View {
    @State var checklist: Checklist
    @State var now = TimeDataSource<Date>.currentDate

    var body: some View {
        switch checklist.status {
        case .unloaded:
            Button {
                checklist.load()
            } label: {
                HStack {
                    relativeDate
                    Text(checklist.id)
                    Text("unloaded")
                }
            }
        case let .loading(startTime):
            HStack {
                relativeDate
                Text(checklist.id)
                Text("loading")
                Text(startTime, relativeTo: now)
            }
        case let .value(eBirdChecklist):
            NavigationLink {
                ChecklistView(checklist: eBirdChecklist)
            } label: {
                HStack {
                    relativeDate
                    Text(checklist.id)
                }
            }
        case let .error(reason):
            HStack {
                relativeDate
                Text(checklist.id)
                Text("error: \(reason)")
            }
        }
    }

    var relativeDate: some View {
        Text(checklist.date, relativeTo: now)
    }
}

#Preview {
    List {
        ChecklistLinkView(checklist: Checklist(
            for: "one",
            date: Calendar.current.startOfDay(for: Date.now),
            status: .unloaded
        ))
        ChecklistLinkView(checklist: Checklist(
            for: "two",
            date: Calendar.current.startOfDay(for: Date.now),
            status: .loading(startTime: Date.now)
        ))
        ChecklistLinkView(checklist: Checklist(
            for: "four",
            date: Calendar.current.startOfDay(for: Date.now),
            status: .error(reason: "oops I lost")
        ))
    }
}
