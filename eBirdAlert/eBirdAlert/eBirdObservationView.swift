// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct eBirdObservationView: View {
    @State var e: eBirdObservation
    @State var checklist: Checklist

    init(_ e: eBirdObservation,
         in checklist: Checklist)
    {
        self.e = e
        self.checklist = checklist
    }

    var body: some View {
        VStack {
            Text("\(e.howMany ?? 1) \(e.comName)")
            Text(e.locName)
            Text(e.obsDt.eBirdFormatted)
            Text(e.userDisplayName)
            Spacer()
            if let comments = checklist.observation(for: e.obsId)?.comments {
                Label("sighting comments", systemImage: "location.square")
                Text(comments)
                Spacer()
            }
            switch checklist.status {
            case .unloaded:
                Text("unknown")
            case let .loading(startTime):
                Text("loading \(startTime.relative())")
            case let .value(checklist):
                if let comments = checklist.comments {
                    Label("general comments", systemImage: "globe.americas")
                    Text(comments)
                    Spacer()
                }
            case let .error(reason):
                Text("error: \(reason)")
            }
        }
    }
}
