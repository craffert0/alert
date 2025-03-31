// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct NotableObservationsView: View {
    @Environment(NotableObservationsProvider.self) var provider
    @State var isLoading = false
    @State private var error: eBirdServiceError?
    @State private var hasError = false

    var body: some View {
        NavigationView {
            List {
                ForEach(provider.observations) { o in
                    Text("\(o.speciesCode): \(o.comName)")
                }
            }
            .listStyle(.inset)
            .navigationTitle("Notable Sightings")
            // .toolbar(content: toolbarContent)
            // .environment(\.editMode, $editMode)
            .refreshable {
                await refresh()
            }
            .alert(isPresented: $hasError, error: error) {}
        }
        .task {
            await refresh()
        }
    }

    func refresh() async {
        isLoading = true
        do {
            try await provider.refresh()
        } catch {
            self.error = error as? eBirdServiceError ?? .unexpectedError(error: error)
            hasError = true
        }
        isLoading = false
    }
}
