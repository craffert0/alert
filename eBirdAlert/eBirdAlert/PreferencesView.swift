// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct PreferencesView: View {
    @ObservedObject var preferences = PreferencesModel.global
    @State var daysBack: Double = .init(PreferencesModel.global.daysBack)
    @State var showRange: Bool = false
    @State var showLicense: Bool = false
    @State var regionInfo: eBirdRegionInfo? = nil
    private let service: eBirdRegionService = URLSession.region

    private var githubMarkdown =
        "[git@github.com:craffert0/alert]" +
        "(https://github.com/craffert0/alert)"

    var body: some View {
        NavigationStack {
            Form {
                Section("Range") {
                    locationView
                    daysView
                }

                Section("Map") {
                    mapTypeView
                    directionsTypeView
                }

                copyrightView
            }.navigationBarTitle("eBird Alert!")
        }
        .task {
            await loadRegionInfo()
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

    private var locationView: some View {
        Button {
            showRange = true
        } label: {
            switch preferences.rangeOption {
            case .radius:
                HStack {
                    Text("Within")
                    Text(preferences.distValue.formatted(.eBirdFormat))
                    Text(preferences.distUnits.rawValue)
                }
            case .region:
                if let regionInfo {
                    Text(regionInfo.result)
                } else if let regionCode = preferences.regionCode {
                    Text(regionCode)
                } else {
                    Text("dang!")
                }
            }
        }
        .sheet(isPresented: $showRange,
               onDismiss: {
                   Task { @MainActor in await loadRegionInfo() }
               }) {
            RangePreferenceView()
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private func loadRegionInfo() async {
        if let regionCode = preferences.regionCode {
            regionInfo = try? await service.getInfo(for: regionCode)
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
