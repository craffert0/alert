// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct DistancePreferencesView: View {
    private let isInForm: Bool
    @State private var slice: RangePreferenceSlice
    private var distValueReduced: Binding<Double>

    init(isInForm: Bool,
         slice: RangePreferenceSlice)
    {
        self.isInForm = isInForm
        self.slice = slice
        distValueReduced = Binding {
            slice.distValue.reduced
        } set: { newValue in
            slice.distValue = newValue.expanded
        }
    }

    var body: some View {
        HStack {
            Label("", systemImage: "figure.walk.circle")

            if !isInForm {
                slider
            }
            Picker(selection: $slice.distUnits) {
                Text("miles").tag(DistanceUnits.miles)
                Text("km").tag(DistanceUnits.kilometers)
            } label: {
                if isInForm {
                    slider
                } else {
                    Text("")
                }
            }
        }
    }

    private var slider: some View {
        HStack {
            Slider(value: distValueReduced,
                   in: 1.reduced ... .maxNotableDistance.reduced)
            Text(slice.distValue.formatted(.eBirdFormat))
        }
    }
}

#Preview {
    Form {
        DistancePreferencesView(
            isInForm: true,
            slice: RangePreferenceSlice(from: PreferencesModel.global)
        )
        TextField("distance",
                  value: PreferencesModel.global.$distValue,
                  formatter: {
                      let n = NumberFormatter()
                      n.usesSignificantDigits = true
                      return n
                  }())
    }
}
