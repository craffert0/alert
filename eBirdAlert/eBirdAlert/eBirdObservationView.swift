// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct eBirdObservationView: View {
    let e: eBirdObservation
    let checklist: Checklist

    init(_ e: eBirdObservation) {
        self.e = e
        checklist = SwiftDataService.shared.load(checklist: e.subId)
    }

    var body: some View {
        VStack {
            Text(e.comName)
            Text(e.locName)
            Spacer()
            switch checklist.status {
            case .unloaded:
                Text("maybe load?")
            case let .loading(startTime):
                Text("loading \(startTime.distance(to: Date.now).english)")
            case let .value(checklist):
                if let comments = checklist.comments {
                    Label("general comments", systemImage: "globe.americas")
                    Text(comments)
                    Spacer()
                }
            case let .error(reason):
                Text("error: \(reason)")
            }
            if let comments = checklist.observation(for: e.obsId)?.comments {
                Label("sighting comments", systemImage: "location.square")
                Text(comments)
                Spacer()
            }
        }
    }
}
