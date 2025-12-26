// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct NotableObservationsView: View {
    @Environment(NotificationService.self) private var notificationService
    @State var provider: NotableObservationsProvider
    @State var model: ObservationsProviderModel
    @ObservedObject var preferences = PreferencesModel.global
    @State var now = TimeDataSource<Date>.currentDate
    @State private var observationSort: ObservationSortOption = .byTime

    init(provider: NotableObservationsProvider) {
        self.provider = provider
        model = ObservationsProviderModel(provider: provider)
    }

    var body: some View {
        ZStack(alignment: .center) {
            mainView
            if model.isLoading {
                ProgressView()
            }
        }
    }

    private var mainView: some View {
        NavigationStack {
            RangeView(range: provider.loadedRange)
            if !model.isLoading, provider.observations.isEmpty {
                EmptyView(name: "rare", range: provider.loadedRange)
            } else {
                VStack {
                    HStack {
                        Text(preferences.daysBackString)
                        Spacer()
                        SortPickerView(observationSort: $observationSort)
                    }.padding()
                    listView
                }
                .navigationTitle("Rarities")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .task {
            await model.load()
            try? await notificationService.clearBadgeCount()
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
            if let grouped = observationSort.group(provider.observations) {
                List {
                    ForEach(grouped, id: \.0) { pair in
                        Section(pair.0.rawValue) {
                            ForEach(pair.1) { o in
                                link(for: o)
                            }
                        }
                    }
                }
            } else {
                List(observationSort.sort(provider.observations)) { o in
                    link(for: o)
                }
            }
        }
        .refreshable {
            await model.refresh()
        }
    }

    private func link(for o: BirdObservations) -> some View {
        NavigationLink {
            BirdObservationsView(o)
        } label: {
            Text(o.latestSighting, relativeTo: now)
            Text(o.comName)
            Text("(\(o.locations.total_count))")
        }
    }
}

#Preview {
    let checklistDataService = FakeChecklistDataService()
    let locationService = FixedLocationService(latitude: 41, longitude: -74)
    TabView {
        Tab("None", systemImage: "bird.circle.fill") {
            let provider = NotableObservationsProvider(
                client: FakeObservationsClient(observations: []),
                checklistDataService: checklistDataService,
                locationService: locationService
            )
            NotableObservationsView(provider: provider)
        }
        Tab("Some", systemImage: "bird.circle") {
            let provider = NotableObservationsProvider(
                client: FakeObservationsClient(observations: .fake),
                checklistDataService: checklistDataService,
                locationService: locationService
            )
            NotableObservationsView(provider: provider)
        }
    }
}
