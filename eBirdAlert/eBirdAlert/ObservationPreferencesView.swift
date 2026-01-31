// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct ObservationPreferencesView: View {
    @State var model: ObservationsProviderModel
    @Binding var sort: ObservationSortOption

    var body: some View {
        LocationView {
            await model.load()
        }
        HStack {
            DaysBackPickerView {
                await model.load()
            }
            Spacer()
            SortPickerView(
                observationSort: $sort
            )
        }.padding()
    }
}
