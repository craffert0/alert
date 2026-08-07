// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct SecretPreferencesView: View {
    @ObservedObject var preferences = PreferencesModel.global
    @State var userToken: String = PreferencesModel.global.userToken ?? ""
    @State var showAuthenticationKey: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    Button("eBird Authentication Key", systemImage: "key") {
                        showAuthenticationKey = true
                    }.sheet(isPresented: $showAuthenticationKey) {
                        AuthenticationKeyView()
                    }
                }
                Section("Notifications") {
                    TextField("User Token", text: $userToken)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .font(.body.monospaced())
                        .onSubmit {
                            if userToken == "" {
                                preferences.userToken = nil
                            } else {
                                preferences.userToken = userToken
                            }
                        }
                }
            }.navigationBarTitle("Secret Settings")
        }
    }
}

#Preview {
    let locationService: LocationService =
        FixedLocationService(latitude: 41, longitude: -74)
    VStack {
        SecretPreferencesView()
            .environment(locationService)
    }
}
