// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct DistancePreferencesView: View {
    @ObservedObject var preferences = PreferencesModel.global
    private var distValueReduced = Binding {
        PreferencesModel.global.distValue.reduced
    } set: { newValue in
        Task { @MainActor in
            PreferencesModel.global.distValue = newValue.expanded
        }
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
            Slider(value: distValueReduced,
                   in: 1.reduced ... preferences.maxDistance.reduced)
            Text(preferences.distValue.formatted(.eBirdFormat))
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
