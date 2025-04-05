// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct NotableObservationsView: View {
    let locationService = LocationService.global

    @Environment(NotableObservationsProvider.self) var provider
    @State var isLoading = false
    @State private var error: eBirdServiceError?
    @State private var hasError = false
    @State private var lastLoadTime: Date?

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
            .navigationBarTitleDisplayMode(.inline)
            // .toolbar(content: toolbarContent)
            // .environment(\.editMode, $editMode)
            .refreshable {
                await refresh()
            }
            .alert(isPresented: $hasError, error: error) {}
        }
        .task {
            await load()
        }
    }

    func load() async {
        if Date.now.timeIntervalSince(lastLoadTime ?? Date.distantPast) > 3600 {
            await refresh()
        }
    }

    func refresh() async {
        isLoading = true
        do {
            try await provider.refresh()
            lastLoadTime = Date.now
        } catch {
            self.error = error as? eBirdServiceError ?? .unexpectedError(error: error)
            hasError = true
        }
        isLoading = false
    }
}
