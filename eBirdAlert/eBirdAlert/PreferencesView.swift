// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct PreferencesView: View {
    @ObservedObject var preferences = PreferencesModel.global
    @State var daysBack: Double = .init(PreferencesModel.global.daysBack)
    @State var showLicense: Bool = false

    private var githubMarkdown =
        "[git@github.com:craffert0/alert]" +
        "(https://github.com/craffert0/alert)"

    var body: some View {
        NavigationStack {
            Form {
                Section("Range") {
                    daysView
                    DistancePreferencesView()
                }

                Section("Map") {
                    mapTypeView
                    directionsTypeView
                }

                copyrightView
            }.navigationBarTitle("eBird Alert!")
        }
    }

    private var daysView: some View {
        HStack {
            Label("", systemImage: "calendar.circle")

            Slider(value: $daysBack, in: 1 ... 8, step: 1.0) {
                _ in preferences.daysBack = Int(daysBack)
            }

            Text(
                "\(Int(daysBack)) day" +
                    (Int(daysBack) == 1 ? "" : "s")
            )
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
}

#Preview {
    PreferencesView()
}
