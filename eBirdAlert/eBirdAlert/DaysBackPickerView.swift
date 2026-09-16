// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct DaysBackPickerView: View {
    @ObservedObject var preferences = PreferencesModel.global

    var body: some View {
        Picker("Days", selection: preferences.$daysBack) {
            ForEach(1 ..< 9) { days in
                Text(days.daysBackString).tag(days)
            }
        }
    }
}

#Preview {
    VStack {
        DaysBackPickerView()
    }
}
