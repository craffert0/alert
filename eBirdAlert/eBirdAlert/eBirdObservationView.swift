// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct eBirdObservationView: View {
    @State var e: eBirdObservation
    @State var checklist: Checklist
    @State var showSpecies: Bool = false

    init(_ e: eBirdObservation,
         in checklist: Checklist)
    {
        self.e = e
        self.checklist = checklist
    }

    var body: some View {
        VStack {
            Button("\(e.howMany ?? 1) \(e.comName)") {
                showSpecies = true
            }.sheet(isPresented: $showSpecies) {
                SafariView(speciesCode: e.speciesCode, site: .ebird)
            }
            Text(e.obsDt.eBirdFormatted)
            LocationButton(location: e)
            Text(e.userDisplayName)
            Spacer()
            if let comments = checklist.observation(for: e.obsId)?.comments {
                Label("sighting comments", systemImage: "location.square")
                Text(comments)
                    .textSelection(.enabled)
                    .padding()
                Spacer()
            }
            if case let .value(checklist) = checklist.status,
               let comments = checklist.comments
            {
                Label("general comments", systemImage: "globe.americas")
                Text(comments)
                    .textSelection(.enabled)
                    .padding()
                Spacer()
            }
        }
    }
}

#Preview {
    eBirdObservationView(.fake, in: Checklist(for: "fake",
                                              date: Date.now,
                                              status: .unloaded))
}
