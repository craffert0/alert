// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension SafariView {
    enum Site {
        case ebird
        case macaulay
        case photos
    }

    init(speciesCode: String, site: Site) {
        self.init(url: site.url(for: speciesCode))
    }
}

extension SafariView.Site {
    func url(for speciesCode: String) -> URL {
        switch self {
        case .ebird:
            URL(string: "https://ebird.org/species/" + speciesCode)!
        case .macaulay:
            URL(string: "https://search.macaulaylibrary.org/catalog" +
                "?taxonCode=" + speciesCode + "&sort=rating_rank_desc")!
        case .photos:
            URL(string: "https://ebird.org/checklist/" + speciesCode +
                "?view=photos")!
        }
    }
}
