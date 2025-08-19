// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct eBirdObservationView: View {
    @State var e: eBirdObservation
    @State var checklist: Checklist
    @State var showSpecies: Bool = false
    @State var showPhotos: Bool = false

    init(_ e: eBirdObservation,
         in checklist: Checklist)
    {
        self.e = e
        self.checklist = checklist
    }

    var obs: eBirdChecklist.Obs? { checklist.observation(for: e.obsId) }

    var body: some View {
        VStack {
            speciesView
            Text(e.obsDt.eBirdFormatted)
            LocationButton(location: e)
            Text(e.userDisplayName)
            if let hasMedia = obs?.hasMedia, hasMedia {
                Button("Photos") {
                    showPhotos = true
                }.sheet(isPresented: $showPhotos) {
                    SafariView(code: checklist.id, site: .photos)
                }
            }
            Spacer()
            if let comments = obs?.comments {
                Label("sighting comments", systemImage: "location.square")
                Text(comments)
                    .textSelection(.enabled)
                    .padding()
                Spacer()
            }
            if case let .value(checklist) = checklist.status {
                eBirdChecklistView(checklist: checklist)
            }
        }
    }

    private var speciesView: some View {
        Button("\(e.howMany ?? 1) \(e.comName)") {
            showSpecies = true
        }.sheet(isPresented: $showSpecies) {
            SafariView(code: e.speciesCode, site: .ebird)
        }
    }
}

#Preview {
    eBirdObservationView(.fake, in: Checklist(for: "fake",
                                              date: Date.now,
                                              status: .unloaded))
}
