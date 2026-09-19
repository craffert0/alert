// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct SortPickerView: View {
    @Binding var observationSort: ObservationSortOption

    var body: some View {
        ViewThatFits {
            pickerView { "Sort \($0.viewString)" }
            pickerView { $0.viewString }
            pickerView { $0.shortString }
        }
    }

    private func pickerView(_ property: @escaping (ObservationSortOption) -> String) -> some View {
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
        SortPickerView(observationSort: binding)
            .frame(maxWidth: 200)
        SortPickerView(observationSort: binding)
            .frame(maxWidth: 110)
        SortPickerView(observationSort: binding)
            .frame(maxWidth: 100)
    }
}
