// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct SortPickerView: View {
    @Binding var observationSort: ObservationSortOption
    let size: ViewSize

    var body: some View {
        switch size {
        case .large: pickerView { "Sort \($0.viewString)" }
        case .medium: pickerView { $0.viewString }
        case .small: pickerView { $0.shortString }
        }
    }

    private func pickerView(
        _ property: @escaping (ObservationSortOption) -> String
    ) -> some View {
        Picker("Sort", selection: $observationSort) {
            ForEach(ObservationSortOption.allCases) { option in
                Text(property(option))
            }
        }
    }
}

#Preview {
    var option = ObservationSortOption.byName
    let binding = Binding<ObservationSortOption> {
        option
    } set: { newValue in
        option = newValue
    }
    VStack {
        ViewThatFits {
            SortPickerView(observationSort: binding, size: .large)
            SortPickerView(observationSort: binding, size: .medium)
            SortPickerView(observationSort: binding, size: .small)
        }
        .frame(maxWidth: 200)
        ViewThatFits {
            SortPickerView(observationSort: binding, size: .large)
            SortPickerView(observationSort: binding, size: .medium)
            SortPickerView(observationSort: binding, size: .small)
        }
        .frame(maxWidth: 110)
        ViewThatFits {
            SortPickerView(observationSort: binding, size: .large)
            SortPickerView(observationSort: binding, size: .medium)
            SortPickerView(observationSort: binding, size: .small)
        }
        .frame(maxWidth: 100)
    }
}
