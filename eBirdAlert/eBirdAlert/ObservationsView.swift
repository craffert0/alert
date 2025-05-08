// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct ObservationsView: View {
    @State var provider: ObservationsProvider
    @State private var error: eBirdServiceError?
    @State private var showError = false
    @State var now = TimeDataSource<Date>.currentDate

    init(provider: ObservationsProvider) {
        self.provider = provider
    }

    var body: some View {
        NavigationStack {
            List(provider.observations) { o in
                NavigationLink {
                    BirdObservationsView(o)
                } label: {
                    Text(o.latestSighting, relativeTo: now)
                    Text(o.comName)
                    Text("(\(o.locations.total_count))")
                }
            }
            .listStyle(.automatic)
            .navigationTitle("Rarities")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await refresh()
            }
            .alert(isPresented: $showError, error: error) {}
        }
        .task {
            await load()
        }
    }
}

extension ObservationsView {
    func load() async {
        do {
            try await provider.load()
        } catch {
            self.error = eBirdServiceError.from(error)
            showError = true
        }
    }

    func refresh() async {
        do {
            try await provider.refresh()
        } catch {
            self.error = eBirdServiceError.from(error)
            showError = true
        }
    }
}

#Preview {
    let provider = ObservationsProvider(
        client: FakeObservationsClient(observations: .fake),
        checklistDataService: FakeChecklistDataService(),
        locationService: FixedLocationService(latitude: 41, longitude: -74)
    )
    ObservationsView(provider: provider)
}
