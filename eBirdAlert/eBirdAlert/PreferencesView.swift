// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct PreferencesView: View {
    @ObservedObject var preferences = PreferencesModel.global
    @State var daysBack: Double = .init(PreferencesModel.global.daysBack)
    @State var showAuthenticationKey: Bool = false

    var body: some View {
        Form {
            Text("Settings").font(.largeTitle)
            HStack {
                Label("", systemImage: "calendar.circle")
                Slider(value: $daysBack,
                       in: 1 ... 8,
                       step: 1.0,
                       onEditingChanged: { _ in
                           preferences.daysBack = Int(daysBack)
                       })
                Text("\(Int(daysBack)) days")
            }

            HStack {
                Label("", systemImage: "figure.walk.circle")
                Slider(value: preferences.$distValue,
                       in: 1 ... 20,
                       step: 0.1,
                       onEditingChanged: { _ in })
                Picker(
                    preferences.distValue.formatted(
                        .number.rounded(rule: .down, increment: 0.1)
                    ),
                    selection: preferences.$distUnits
                ) {
                    Text("miles").tag(DistanceUnits.miles)
                    Text("km").tag(DistanceUnits.kilometers)
                }
            }

            Picker(selection: preferences.$mapOption) {
                Text("Apple").tag(MapOption.apple)
                Text("Google").tag(MapOption.google)
            } label: {
                Label("Map Type", systemImage: "map.circle")
            }

            Toggle(
                "Debug Mode",
                systemImage: "magnifyingglass.circle",
                isOn: preferences.$debugMode
            )
            Button("eBird Authentication Key", systemImage: "key") {
                showAuthenticationKey = true
            }.sheet(isPresented: $showAuthenticationKey) {
                AuthenticationKeyView()
            }
        }
    }
}

#Preview {
    PreferencesView()
}
