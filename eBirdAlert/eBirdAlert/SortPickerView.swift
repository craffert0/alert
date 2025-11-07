// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct SortPickerView: View {
    @Binding var observationSort: ObservationSortOption

    var body: some View {
        Picker("Sort", selection: $observationSort) {
            ForEach(ObservationSortOption.allCases) { option in
                Text("Sort \(option.rawValue)")
            }
        }
    }
}
