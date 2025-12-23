// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct eBirdChecklistView: View {
    @State var checklist: eBirdChecklist
    let species: String
    private var others: [eBirdChecklist.Obs] {
        checklist.obs.compactMap {
            $0.speciesCode != species ? $0 : nil
        }
    }

    var body: some View {
        Label("Checklist", systemImage: "globe.americas")
        VStack {
            if let comments = checklist.comments {
                Text(comments)
                    .textSelection(.enabled)
                    .padding()
            }
            List(others) { o in
                ObsView(obs: o)
            }.listStyle(.grouped)
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
    VStack {
        eBirdChecklistView(checklist: .fake, species: "mutswa")
    }
}
