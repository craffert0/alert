// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct AuthenticationKeyView: View {
    @State var applicationKey: String = ""

    var body: some View {
        VStack {
            Form {
                Label("eBird Authentication Key", systemImage: "key")

                Text(try! AttributedString(
                    markdown:
                    "In order to use this application, you must have an " +
                        "eBird account, and on their site, you must " +
                        "[request an Authentication Key]" +
                        "(https://ebird.org/api/keygen), and enter that " +
                        "in the field below."))

                SecureField(text: $applicationKey,
                            prompt: Text("eBird authentication key"))
                {
                    Text("App Key")
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onSubmit {
                    print("[\(applicationKey)]")
                    do {
                        try KeychainService.global.set(
                            applicationKey: applicationKey)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}

#Preview {
    AuthenticationKeyView()
}
