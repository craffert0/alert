// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct LocalsView: View {
    @Environment(LocationService.self) var locationService
    @ObservedObject var preferences = PreferencesModel.global
    @State var model: LocalsModel

    var body: some View {
        if locationService.location == nil {
            Text("no location 😢")
        } else {
            ZStack(alignment: .center) {
                splitView
                if model.isLoading {
                    ProgressView()
                }
            }
            .task {
                await model.load()
            }
            .alert(isPresented: $model.showError, error: model.error) { _ in
            } message: { e in
                e.view
            }
        }
    }

    private var splitView: some View {
        NavigationSplitView {
            VStack {
                preferencesView
                mainView
            }
        } content: {
            contentView
        } detail: {
            detailView
        }
    }

    private var mainView: some View {
        Text("main")
    }

    private var preferencesView: some View {
        ObservationPreferencesView(model: model,
                                   sort: preferences.$localsSort)
    }

    @ViewBuilder
    private var contentView: some View {}

    @ViewBuilder
    private var detailView: some View {}
}
