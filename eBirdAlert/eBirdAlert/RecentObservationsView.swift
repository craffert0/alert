// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct RecentObservationsView: View {
    @Environment(LocationService.self) var locationService
    @State var provider: RecentObservationsProvider
    @State private var error: eBirdServiceError?
    @State private var showError = false
    @State var now = TimeDataSource<Date>.currentDate
    @State var loading = false

    init(provider: RecentObservationsProvider) {
        self.provider = provider
    }

    var body: some View {
        if locationService.location == nil {
            Text("no location 😢")
        } else {
            mainView
        }
    }

    private var mainView: some View {
        NavigationStack {
            if !loading, provider.observations.isEmpty {
                EmptyView()
            } else {
                listView
            }
        }
        .task {
            await load()
        }
        .alert(isPresented: $showError, error: error) { _ in
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
        List(provider.observations) { o in
            HStack {
                Text(o.obsDt, relativeTo: now)
                Text(o.comName)
            }
        }
    }
}

extension RecentObservationsView {
    func load() async {
        loading = true
        do {
            try await tryLoading()
        } catch {
            self.error = eBirdServiceError.from(error)
            showError = true
        }
        loading = false
    }

    private func tryLoading() async throws {
        try await provider.load()
        // TODO: all the other BS
    }
}

// #Preview {
//     VStack {
//         RecentObservationsView()
//     }
// }
