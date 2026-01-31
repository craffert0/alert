// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct GroupedListView<Observation: ObservationSortable & Identifiable, Content: View>: View {
    let observations: [Observation]
    let sort: ObservationSortOption
    let model: ObservationsProviderModel
    let link: (Observation) -> Content

    var body: some View {
        Group {
            if let grouped = sort.group(observations) {
                List {
                    ForEach(grouped, id: \.0) { pair in
                        Section(pair.0.rawValue) {
                            ForEach(pair.1) { o in
                                link(o)
                            }
                        }
                    }
                }
            } else {
                List(sort.sort(observations)) { o in
                    link(o)
                }
            }
        }
        .refreshable {
            await model.refresh()
        }
    }
}
