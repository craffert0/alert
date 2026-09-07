// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension SafariView {
    enum Site {
        case ebird(String)
        case macaulay(String)
        case checklist(String)
        case photos(String, species: String)
    }

    init(site: Site) {
        self.init(url: site.url)
    }
}

extension SafariView.Site {
    var url: URL {
        switch self {
        case let .ebird(species):
            URL(string: "https://ebird.org/species/" + species)!
        case let .macaulay(species):
            URL(string: "https://search.macaulaylibrary.org/catalog" +
                "?taxonCode=" + species + "&sort=rating_rank_desc")!
        case let .checklist(name):
            URL(string: "https://ebird.org/checklist/" + name)!
        case let .photos(checklist, species):
            URL(string: "https://ebird.org/checklist/" + checklist +
                "?view=photos#" + species)!
        }
    }
}
