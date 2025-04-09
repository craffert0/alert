// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct ChecklistView: View {
    let checklist: eBirdChecklist

    var body: some View {
        VStack {
            Text(checklist.userDisplayName).font(.largeTitle)
            Text(checklist.comments ?? "no comment")
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(checklist.obs) { o in
                        ObsView(obs: o)
                    }
                }
            }
        }
    }

    struct ObsView: View {
        let obs: eBirdChecklist.Obs
        @State var showSpecies: Bool = false

        var body: some View {
            HStack {
                if let how = obs.howManyStr {
                    Text(how)
                }
                Button(obs.speciesCode) {
                    showSpecies = true
                }.sheet(isPresented: $showSpecies) {
                    SafariView(speciesCode: obs.speciesCode)
                }
                if let c = obs.comments {
                    Text(c)
                }
            }
        }
    }
}
