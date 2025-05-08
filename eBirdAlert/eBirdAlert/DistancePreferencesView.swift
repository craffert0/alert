// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct DistancePreferencesView: View {
    @ObservedObject var preferences = PreferencesModel.global
    private var distValueLog = Binding {
        log(PreferencesModel.global.distValue)
    } set: { newValue in
        PreferencesModel.global.distValue = exp(newValue)
    }

    var body: some View {
        HStack {
            Label("", systemImage: "figure.walk.circle")

            Picker(selection: preferences.$distUnits) {
                Text("miles").tag(DistanceUnits.miles)
                Text("km").tag(DistanceUnits.kilometers)
            } label: {
                slider
            }
        }
    }

    private var slider: some View {
        HStack {
            Slider(value: distValueLog, in: 0 ... log(999))
            Text(
                preferences.distValue.formatted(
                    .number.rounded(rule: .toNearestOrAwayFromZero,
                                    increment: 0.1)
                )
            )
        }
    }
}

#Preview {
    Form {
        DistancePreferencesView()
        TextField("distance",
                  value: PreferencesModel.global.$distValue,
                  formatter: {
                      let n = NumberFormatter()
                      n.usesSignificantDigits = true
                      return n
                  }())
    }
}
