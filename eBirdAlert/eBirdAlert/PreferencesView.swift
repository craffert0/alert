// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct PreferencesView: View {
    @ObservedObject var preferences = PreferencesModel.global
    @State var daysBack: Double = .init(PreferencesModel.global.daysBack)

    var body: some View {
        Form {
            HStack {
                Slider(value: $daysBack,
                       in: 1 ... 8,
                       step: 1.0,
                       onEditingChanged: { _ in
                           preferences.daysBack = Int(daysBack)
                       })
                Text("\(Int(daysBack)) days")
            }

            HStack {
                Slider(value: preferences.$distValue,
                       in: 1 ... 20,
                       onEditingChanged: { _ in })
                Picker(
                    preferences.distValue.formatted(
                        .number.rounded(rule: .down, increment: 0.01)
                    ),
                    selection: preferences.$distUnits
                ) {
                    Text("miles").tag(DistanceUnits.miles)
                    Text("km").tag(DistanceUnits.kilometers)
                }
            }

            Picker("Map Type", selection: preferences.$mapOption) {
                Text("Apple").tag(MapOption.apple)
                Text("Google").tag(MapOption.google)
            }

            HStack {
                Label("eBird Key:", systemImage: "key")
                TextField(text: preferences.$applicationKey,
                          prompt: Text("eBird application key"))
                {
                    Text("App Key")
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            }
        }
    }
}

#Preview {
    PreferencesView()
}
