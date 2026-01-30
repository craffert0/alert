// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct PreferencesView: View {
    @ObservedObject var preferences = PreferencesModel.global
    @State var daysBack: Double = .init(PreferencesModel.global.daysBack)
    @State var showLicense: Bool = false
    private let service: eBirdRegionService = URLSession.region

    private var githubMarkdown =
        "[git@github.com:craffert0/alert]" +
        "(https://github.com/craffert0/alert)"

    var body: some View {
        NavigationStack {
            Form {
                Section("Map") {
                    mapTypeView
                    directionsTypeView
                }

                notificationsView

                copyrightView
            }.navigationBarTitle("eBird Alert!")
        }
    }

    private var mapTypeView: some View {
        Picker("Map Type", selection: preferences.$mapType) {
            ForEach(MapOption.allCases) { option in
                Text(option.rawValue.capitalized)
            }
        }
    }

    private var directionsTypeView: some View {
        Picker("Directions", selection: preferences.$directionsType) {
            ForEach(MapDirectionsOption.allCases) { option in
                Text(option.rawValue.capitalized)
            }
        }
    }

    private var copyrightView: some View {
        Section("Info") {
            Text(
                "Copyright © 2025 Colin Rafferty and Marleny Rafferty"
            )
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .onTapGesture(count: 10) {
                preferences.debugMode = true
            }

            Button("Licensed GNU GPLv2.0") {
                showLicense = true
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .sheet(isPresented: $showLicense) {
                LicenseView(model: LicenseModel())
            }

            Text(
                try! AttributedString(markdown: githubMarkdown)
            )
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private var notificationsView: some View {
        Section("Notifications") {
            Toggle(isOn: preferences.$notifyNotable) {
                Text("Notify on new rarities")
            }
            .onChange(of: preferences.notifyNotable) { _, newValue in
                if newValue {
                    Task { @MainActor in
                        try? await UNUserNotificationCenter.current()
                            .requestAuthorization(options: [.alert, .badge, .sound])
                    }
                }
            }
        }
    }
}

#Preview {
    let locationService: LocationService =
        FixedLocationService(latitude: 41, longitude: -74)
    PreferencesView()
        .environment(locationService)
}
