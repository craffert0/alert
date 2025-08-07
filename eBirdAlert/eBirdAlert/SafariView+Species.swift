// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension SafariView {
    enum Site {
        case ebird
        case macaulay
        case photos
    }

    init(code: String, site: Site) {
        self.init(url: site.url(for: code))
    }
}

extension SafariView.Site {
    func url(for code: String) -> URL {
        switch self {
        case .ebird:
            URL(string: "https://ebird.org/species/" + code)!
        case .macaulay:
            URL(string: "https://search.macaulaylibrary.org/catalog" +
                "?taxonCode=" + code + "&sort=rating_rank_desc")!
        case .photos:
            URL(string: "https://ebird.org/checklist/" + code +
                "?view=photos")!
        }
    }
}
