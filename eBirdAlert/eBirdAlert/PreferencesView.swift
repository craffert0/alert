// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct PreferencesView: View {
    var preferences = PreferencesModel.global

    var body: some View {
        Form {
            Label("eBird Application Key", systemImage: "key")
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

#Preview {
    PreferencesView()
}
