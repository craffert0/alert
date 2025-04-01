// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI
import WebKit

struct SpeciesDetailView: UIViewRepresentable {
    let species: Species

    func makeUIView(context _: Context) -> WKWebView {
        let wkwebView = WKWebView()
        let url =
            URL(string: "https://ebird.org/species/\(species.speciesCode)")!
        wkwebView.load(URLRequest(url: url))
        return wkwebView
    }

    func updateUIView(_: WKWebView, context _: Context) {}
}
