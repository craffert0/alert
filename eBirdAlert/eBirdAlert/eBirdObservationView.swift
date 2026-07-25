// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct eBirdObservationView: View {
    @State var e: eBirdObservationProtocol
    @State var checklist: Checklist
    @State var showChecklist: Bool = false
    @State var showSpecies: Bool = false
    @State var showPhotos: Bool = false

    init(_ e: eBirdObservationProtocol,
         in checklist: Checklist)
    {
        self.e = e
        self.checklist = checklist
    }

    var obs: eBirdChecklist.Obs? { checklist.observation(for: e.speciesCode) }

    var body: some View {
        VStack {
            userView
            LocationButton(location: e)
            speciesView
            if let hasMedia = obs?.hasMedia, hasMedia {
                photosView
            }
            if case let .value(actual) = checklist.status {
                listView(actual)
            } else {
                topCommentsView
            }
        }
        .navigationTitle(e.obsDt.eBirdFormatted)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var topCommentsView: some View {
        Group {
            if let comments = obs?.comments {
                Text(comments)
                    .textSelection(.enabled)
                    .padding()
            }
        }
    }

    private var userView: some View {
        Button(checklist.userDisplayName ?? "Checklist") {
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
        Button("📸 photos 📸") {
            showPhotos = true
        }.sheet(isPresented: $showPhotos) {
            SafariView(code: checklist.id, site: .photos)
        }
    }

    private func listView(_ actual: eBirdChecklist) -> some View {
        List {
            topCommentsView
            HStack {
                Image(systemName: "globe.americas")
                Text("Checklist")
                Image(systemName: "globe.europe.africa")
            }.frame(maxWidth: .infinity, alignment: .center)

            if let comments = actual.comments {
                Text(comments)
                    .textSelection(.enabled)
                    .padding()
            }
            ForEach(
                actual.obs.compactMap {
                    $0.speciesCode != e.speciesCode ? $0 : nil
                }
            ) {
                ObsView(obs: $0)
            }
        }
        .refreshable {
            await checklist.refresh()
        }
    }

    struct ObsView: View {
        @State var obs: eBirdChecklist.Obs
        @State var showSpecies: Bool = false

        var body: some View {
            VStack {
                Button("\(obs.howManyStr ?? "1") \(obs.printableName)") {
                    showSpecies = true
                }.sheet(isPresented: $showSpecies) {
                    SafariView(code: obs.speciesCode, site: .ebird)
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                if let c = obs.comments {
                    Text(c)
                        .textSelection(.enabled)
                        .padding([.horizontal])
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        eBirdObservationView(
            eBirdObservation.fake,
            in: Checklist(for: "fake",
                          date: Date.now,
                          status: .value(checklist: .fake))
        )
    }
}
