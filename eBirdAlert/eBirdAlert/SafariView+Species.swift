// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension SafariView {
    init(speciesCode: String) {
        let url =
            URL(string: "https://ebird.org/species/\(speciesCode)")!
        self.init(url: url)
    }
}
