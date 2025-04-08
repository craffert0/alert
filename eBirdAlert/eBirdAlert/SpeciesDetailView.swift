// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SafariServices
import SwiftUI

struct SpeciesDetailView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController
    typealias Context =
        UIViewControllerRepresentableContext<SpeciesDetailView>

    let species: Species

    func makeUIViewController(context _: Context) -> SFSafariViewController {
        let url =
            URL(string: "https://ebird.org/species/\(species.speciesCode)")!
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_: SFSafariViewController, context _: Context) {}
}
