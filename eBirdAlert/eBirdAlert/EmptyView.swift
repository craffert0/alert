// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct EmptyView: View {
    @ObservedObject var preferences = PreferencesModel.global

    var body: some View {
        Form {
            Text(emptyText)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.largeTitle)
            Text("Consider expanding your range in your Settings")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.largeTitle)
        }
        .navigationTitle("No Rare Birds")
        .navigationBarTitleDisplayMode(.large)
    }

    private var emptyText: String {
        let daysBack = Int(preferences.daysBack)
        let days = daysBack == 1 ? "day" : "\(daysBack) days"
        let distance = preferences.distValue.formatted(.eBirdFormat)
            + " "
            + preferences.distUnits.rawValue

        return "In the past \(days), there has been no" +
            " rare bird sighting within \(distance)."
    }
}

#Preview {
    VStack {
        EmptyView()
    }
}
