// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct MergedMainView<
    Observation: ObservationSortable & Identifiable & Matchable,
    Content: View
>: View {
    @Environment(MergedModel.self) var model
    @State var searchText: String = ""
    @State var isExpanded: [eBirdFamily: Bool] = [:]

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
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    var listView: some View {
        switch sort.wrappedValue.sort(restrictedObservations) {
        case let .grouped(grouped):
            groupButtonView
            List(selection: selection) {
                ForEach(grouped, id: \.0) { pair in
                    Section(pair.0.comName,
                            isExpanded: Binding(
                                get: { isExpanded[pair.0] ?? true },
                                set: { isExpanded[pair.0] = $0 }
                            )) {
                        ForEach(pair.1) {
                            content($0)
                        }
                    }
                }
            }
        case let .sorted(array):
            List(array, selection: selection) {
                content($0)
            }
        }
    }

    @ViewBuilder
    var groupButtonView: some View {
        if isExpanded.values.contains(false) {
            Button("Open All Sections") {
                withAnimation {
                    isExpanded = [:]
                }
            }
        } else {
            Button("Close All Sections") {
                if case let .grouped(grouped) =
                    sort.wrappedValue.sort(restrictedObservations)
                {
                    withAnimation {
                        for (family, _) in grouped {
                            isExpanded[family] = false
                        }
                    }
                }
            }
        }
    }
}
