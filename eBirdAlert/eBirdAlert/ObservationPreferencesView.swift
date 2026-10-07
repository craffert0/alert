// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct ObservationPreferencesView: View {
    @Binding var sort: ObservationSortOption

    var body: some View {
        LocationView()
        ViewThatFits {
            lineTwoView(size: .large)
            lineTwoView(size: .medium)
            lineTwoView(size: .small)
        }
    }

    func lineTwoView(size: ViewSize) -> some View {
        HStack {
            DaysBackPickerView(size: size)
            Spacer()
            SortPickerView(
                observationSort: $sort,
                size: size
            )
        }.padding(.horizontal)
    }
}
