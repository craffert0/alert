// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI
import URLNetwork

private let kTitleKey = "App Key"
private let kPrompt = Text("eBird authentication key")

struct AuthenticationKeyView: View {
    @Environment(\.dismiss) private var dismiss
    @State var applicationKey: String =
        (try? KeychainService.global.applicationKey) ?? ""
    @State var visibleText: Bool = false
    @FocusState private var textFocused: Bool
    @FocusState private var secureFocused: Bool

    var body: some View {
        VStack {
            Form {
                Label("eBird Authentication Key", systemImage: "key")

                Text(try! AttributedString(
                    markdown:
                    "To more consistently use this application, you may " +
                        "[request an Authentication Key]" +
                        "(https://ebird.org/api/keygen) from eBird.org " +
                        "and enter that key in the field below."
                ))

                HStack {
                    textField
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .font(.body.monospaced())
                        .onSubmit {
                            submit()
                        }
                    Button("",
                           systemImage: visibleText ? "eye" : "eye.slash")
                    {
                        visibleText.toggle()
                    }
                }
            }

            Spacer()

            Button("Cancel") {
                cancel()
            }
        }
    }

    @ViewBuilder
    private var textField: some View {
        if visibleText {
            TextField(kTitleKey,
                      text: $applicationKey,
                      prompt: kPrompt)
                .focused($textFocused)
                .onAppear { textFocused = true }
        } else {
            SecureField(kTitleKey,
                        text: $applicationKey,
                        prompt: kPrompt)
                .focused($secureFocused)
                .onAppear { secureFocused = true }
        }
    }

    private func submit() {
        do {
            try KeychainService.global.set(
                applicationKey: applicationKey
            )
        } catch {
            print(error)
        }
        dismiss()
    }

    private func cancel() {
        applicationKey = (try? KeychainService.global.applicationKey) ?? ""
        dismiss()
    }
}

#Preview {
    AuthenticationKeyView()
}
