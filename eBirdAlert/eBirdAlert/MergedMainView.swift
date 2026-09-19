// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct MergedMainView<
    Observation: ObservationSortable & Identifiable & Matchable,
    Content: View
>: View {
    @Environment(MergedModel.self) var model
    @State var searchText: String = ""

    let observations: [Observation]
    let sort: Binding<ObservationSortOption>
    let name: String
    let selection: Binding<String?>
    let content: (Observation) -> Content

    private var restrictedObservations: [Observation] {
        observations.restrict(by: searchText)
    }

    var body: some View {
        VStack {
            ObservationPreferencesView(sort: sort)
            if observations.isEmpty, !model.isLoading {
                EmptyResultsView(name: name)
            } else {
                listView
                    .searchable(text: $searchText)
                    .refreshable {
                        await model.refresh()
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    var listView: some View {
        if let grouped = sort.wrappedValue.group(restrictedObservations) {
            List(selection: selection) {
                ForEach(grouped, id: \.0) { pair in
                    Section(pair.0.comName) {
                        ForEach(pair.1) {
                            content($0)
                        }
                    }
                }
            }
        } else {
            List(sort.wrappedValue.sort(restrictedObservations),
                 selection: selection)
            {
                content($0)
            }
        }
    }
}
