// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct eBirdChecklistView: View {
    @State var checklist: eBirdChecklist
    let species: String

    var body: some View {
        Label("Checklist", systemImage: "globe.americas")
        ScrollView(.vertical) {
            if let comments = checklist.comments {
                Text(comments)
                    .textSelection(.enabled)
                    .padding()
            }
            LazyVStack {
                ForEach(checklist.obs) { o in
                    if o.speciesCode != species {
                        ObsView(obs: o)
                    }
                }
            }
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
                if let c = obs.comments {
                    Text(c)
                        .textSelection(.enabled)
                        .padding([.horizontal])
                }
            }
        }
    }
}

// #Preview {
//     VStack {
//         eBirdChecklistView()
//     }
// }
