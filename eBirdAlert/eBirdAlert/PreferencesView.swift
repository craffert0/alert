// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct PreferencesView: View {
    @ObservedObject var preferences = PreferencesModel.global

    var body: some View {
        Form {
            Stepper(value: preferences.$daysBack, step: 1) {
                Text("\(preferences.daysBack) days back")
            }

            Stepper(value: preferences.$distMiles, step: 1) {
                Text("\(preferences.distMiles) miles radius")
            }

            List {
                Picker("Map Type", selection: preferences.$mapOption) {
                    Text("Apple").tag(MapOption.apple)
                    Text("Google").tag(MapOption.google)
                }
            }

            HStack {
                Label("eBird Key:", systemImage: "key")
                TextField(text: preferences.$applicationKey,
                          prompt: Text("eBird application key"))
                {
                    Text("App Key")
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            }
        }
    }
}

#Preview {
    PreferencesView()
}
