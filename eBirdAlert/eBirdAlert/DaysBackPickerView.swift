// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct DaysBackPickerView: View {
    @ObservedObject var preferences = PreferencesModel.global
    private var daysBackBinding: Binding<Int>

    init(onChange: @escaping (() async -> Void)) {
        daysBackBinding = Binding {
            PreferencesModel.global.daysBack
        } set: { newValue in
            if PreferencesModel.global.daysBack != newValue {
                PreferencesModel.global.daysBack = newValue
                Task { @MainActor in
                    await onChange()
                }
            }
        }
    }

    var body: some View {
        Picker("Days", selection: daysBackBinding) {
            ForEach(1 ..< 9) { days in
                Text(days.daysBackString).tag(days)
            }
        }
    }
}

#Preview {
    VStack {
        DaysBackPickerView {
            print("done")
        }
    }
}
