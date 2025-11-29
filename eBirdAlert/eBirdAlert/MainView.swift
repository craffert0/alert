// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct MainView: View {
    @Environment(LocationService.self) var locationService
    @State var provider: NotableObservationsProvider

    var body: some View {
        if locationService.location == nil {
            Text("no location 😢")
        } else {
            NotableObservationsView(provider: provider)
        }
    }
}

#Preview {
    let client = FakeObservationsClient(observations: .fake)
    let fixedLocationService: LocationService =
        FixedLocationService(latitude: 41, longitude: -74)
    let noLocationService = LocationService()
    let fixedProvider =
        NotableObservationsProvider(
            client: client,
            checklistDataService: FakeChecklistDataService(),
            locationService: fixedLocationService
        )
    let noProvider =
        NotableObservationsProvider(
            client: client,
            checklistDataService: FakeChecklistDataService(),
            locationService: noLocationService
        )
    TabView {
        Tab("With", systemImage: "location") {
            MainView(provider: fixedProvider)
                .environment(fixedLocationService)
        }
        Tab("Without", systemImage: "location.slash") {
            MainView(provider: noProvider)
                .environment(noLocationService)
        }
    }
}
