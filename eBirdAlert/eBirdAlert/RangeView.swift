// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct RangeView: View {
    @ObservedObject var preferences = PreferencesModel.global

    var body: some View {
        switch preferences.rangeOption {
        case .radius: radiusView
        case .region: regionView
        }
    }

    private var radiusView: some View {
        HStack {
            Text("Within")
            Text(preferences.distValue.formatted(.eBirdFormat))
            Text(preferences.distUnits.rawValue)
        }
    }

    private var regionView: some View {
        HStack {
            Text(preferences.region?.name ?? "In Region")
        }
    }
}

#Preview {
    VStack {
        RangeView()
    }
}
