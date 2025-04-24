// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct ObservationsView: View {
    @Environment(LocationService.self) var locationService
    @State var provider: ObservationsProvider
    @State private var error: eBirdServiceError?
    @State private var hasError = false

    init(provider: ObservationsProvider) {
        self.provider = provider
    }

    var body: some View {
        if locationService.location == nil {
            Text("no location 😢")
        } else {
            properView
        }
    }

    private var properView: some View {
        NavigationView {
            List {
                let now = Date.now
                ForEach(provider.observations) { o in
                    NavigationLink {
                        BirdObservationsView(o)
                    } label: {
                        Text(o.latestSighting.relative(to: now))
                        Text(o.comName)
                        Text("(\(o.locations.total_count))")
                    }
                }
            }
            .listStyle(.automatic)
            .navigationTitle("Rarities")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await refresh()
            }
            .alert(isPresented: $hasError, error: error) {}
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
            hasError = true
        }
    }

    func refresh() async {
        do {
            try await provider.refresh()
        } catch {
            self.error = eBirdServiceError.from(error)
            hasError = true
        }
    }
}
