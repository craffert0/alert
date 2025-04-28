// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct PreferencesView: View {
    @ObservedObject var preferences = PreferencesModel.global
    @State var daysBack: Double = .init(PreferencesModel.global.daysBack)
    @State var showAuthenticationKey: Bool = false

    private var githubMarkdown =
        "[git@github.com:craffert0/alert]" +
        "(https://github.com/craffert0/alert)"

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    daysView
                    distanceView
                } header: {
                    Text("Range")
                }

                Picker("Map Type", selection: preferences.$mapOption) {
                    Text("Apple").tag(MapOption.apple)
                    Text("Google").tag(MapOption.google)
                }
                .pickerStyle(.inline)

                Section {
                    Button("eBird Authentication Key", systemImage: "key") {
                        showAuthenticationKey = true
                    }.sheet(isPresented: $showAuthenticationKey) {
                        AuthenticationKeyView()
                    }
                } header: {
                    Text("Account")
                }

                copyrightView
            }.navigationBarTitle("eBird Alert!")
        }
    }

    private var daysView: some View {
        HStack {
            Label("", systemImage: "calendar.circle")

            Slider(value: $daysBack, in: 1 ... 8, step: 1.0) {
                _ in preferences.daysBack = Int(daysBack)
            }

            Text(
                "\(Int(daysBack)) day" +
                    (Int(daysBack) == 1 ? "" : "s")
            )
        }
    }

    private var distanceView: some View {
        HStack {
            Label("", systemImage: "figure.walk.circle")

            Picker(selection: preferences.$distUnits) {
                Text("miles").tag(DistanceUnits.miles)
                Text("km").tag(DistanceUnits.kilometers)
            } label: {
                HStack {
                    Slider(value: preferences.$distValue,
                           in: 1 ... 20,
                           step: 0.1) {}
                    Text(
                        preferences.distValue.formatted(
                            .number.rounded(rule: .down,
                                            increment: 0.1)
                        )
                    )
                }
            }
        }
    }

    private var copyrightView: some View {
        Section {
            Text("Copyright © 2025 Marleny Rafferty")
                .frame(maxWidth: .infinity, alignment: .center)

            Button("Copyright © 2025 Colin Rafferty") {
                preferences.debugTapCount += 1
                if preferences.debugTapCount > 10 {
                    preferences.debugMode = true
                }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .center)

            NavigationLink {
                LicenseView(model: LicenseModel())
            } label: {
                Text("Licensed GNU GPLv2.0")
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            Text(try! AttributedString(markdown: githubMarkdown))
                .frame(maxWidth: .infinity, alignment: .center)
        } header: {
            Text("Info")
        }
    }
}

#Preview {
    PreferencesView()
}
