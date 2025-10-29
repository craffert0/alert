// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct BirdButtonsView: View {
    let speciesCode: String
    @State var showEBird: Bool = false
    @State var showPhotos: Bool = false

    var body: some View {
        HStack {
            Spacer()

            Button("Identify", systemImage: "person.crop.badge.magnifyingglass") {
                showEBird = true
            }.sheet(isPresented: $showEBird) {
                SafariView(code: speciesCode, site: .ebird)
            }

            Spacer()

            Button("Photos", systemImage: "photo.artframe") {
                showPhotos = true
            }.sheet(isPresented: $showPhotos) {
                SafariView(code: speciesCode, site: .macaulay)
            }

            if UIApplication.shared.canOpenURL(URL(eBird: "bawwar")) {
                Spacer()
                Button("eBird", systemImage: "checklist") {
                    UIApplication.shared.open(URL(eBird: speciesCode))
                }
            }

            Spacer()
        }
    }
}

#Preview {
    VStack {
        BirdButtonsView(speciesCode: "blujay")
    }
}
