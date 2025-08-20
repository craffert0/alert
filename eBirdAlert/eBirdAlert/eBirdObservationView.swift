// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct eBirdObservationView: View {
    @State var e: eBirdObservation
    @State var checklist: Checklist
    @State var showChecklist: Bool = false
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
            userView
            Text(e.obsDt.eBirdFormatted)
            LocationButton(location: e)
            speciesView
            if let hasMedia = obs?.hasMedia, hasMedia {
                photosView
            }
            if let comments = obs?.comments {
                Text(comments)
                    .textSelection(.enabled)
                    .padding()
            }
            if case let .value(checklist) = checklist.status {
                Divider()
                eBirdChecklistView(checklist: checklist,
                                   species: e.speciesCode)
            }
        }
    }

    private var userView: some View {
        Button(e.userDisplayName) {
            showChecklist = true
        }.sheet(isPresented: $showChecklist) {
            SafariView(code: checklist.id, site: .checklist)
        }
    }

    private var speciesView: some View {
        Button("\(e.howMany ?? 1) \(e.comName)") {
            showSpecies = true
        }.sheet(isPresented: $showSpecies) {
            SafariView(code: e.speciesCode, site: .ebird)
        }
    }

    private var photosView: some View {
        Button("Checklist photos") {
            showPhotos = true
        }.sheet(isPresented: $showPhotos) {
            SafariView(code: checklist.id, site: .photos)
        }
    }
}

#Preview {
    eBirdObservationView(.fake, in: Checklist(for: "fake",
                                              date: Date.now,
                                              status: .unloaded))
}
