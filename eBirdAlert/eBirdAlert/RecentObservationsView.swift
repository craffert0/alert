// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct RecentObservationsView: View {
    @Environment(LocationService.self) var locationService
    @State var provider: RecentObservationsProvider
    @State var model: ObservationsProviderModel
    @ObservedObject var preferences = PreferencesModel.global
    @State var now = TimeDataSource<Date>.currentDate
    @State private var observationSort: ObservationSortOption = .byTaxon

    init(provider: RecentObservationsProvider) {
        self.provider = provider
        model = ObservationsProviderModel(provider: provider)
    }

    var body: some View {
        if locationService.location == nil {
            Text("no location 😢")
        } else {
            ZStack(alignment: .center) {
                mainView
                if model.isLoading {
                    ProgressView()
                }
            }
        }
    }

    private var mainView: some View {
        NavigationStack {
            RangeView(range: provider.loadedRange)
            if !model.isLoading, provider.observations.isEmpty {
                EmptyView(name: "local", range: provider.loadedRange)
            } else {
                VStack {
                    HStack {
                        Text(preferences.daysBackString)
                        Spacer()
                        SortPickerView(observationSort: $observationSort)
                    }.padding()
                    listView
                }
                .navigationTitle("Locals")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .task {
            await model.load()
        }
        .alert(isPresented: $model.showError, error: model.error) { _ in
        } message: { e in
            if case let .expandedArea(distance, units) = e {
                Text("eBird could not find birds in the original range," +
                    " so we expanded the range to " +
                    distance.formatted(.eBirdFormat) + " " +
                    units.rawValue + " in order to find some.")
            }
        }
    }

    private var listView: some View {
        Group {
            if observationSort == .byTaxon {
                groupView
            } else {
                simpleListView
            }
        }
        .refreshable {
            await model.refresh()
        }
    }

    var groupedByOrder: [(String, [eBirdRecentObservation])] {
        Dictionary(grouping: provider.observations) {
            $0.order
        }.sorted {
            $0.value.first!.taxonOrder < $1.value.first!.taxonOrder
        }
    }

    private var groupView: some View {
        List {
            ForEach(groupedByOrder, id: \.0) { pair in
                Section(pair.0) {
                    ForEach(observationSort.sort(pair.1)) { o in
                        link(for: o)
                    }
                }
            }
        }
    }

    private var simpleListView: some View {
        List(observationSort.sort(provider.observations)) { o in
            link(for: o)
        }
    }

    private func link(for o: eBirdRecentObservation) -> some View {
        NavigationLink {
            RecentBirdView(o: o,
                           provider: BirdObservationsProvider(
                               for: o.speciesCode,
                               locationService: locationService
                           ))
        } label: {
            Text(o.obsDt, relativeTo: now)
            Text(o.comName)
            Text("(\(Int(o.taxonOrder)))")
        }
    }
}

// #Preview {
//     VStack {
//         RecentObservationsView()
//     }
// }
