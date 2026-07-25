// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension SafariView {
    init(hotspotId: String) {
        self.init(url: URL(string: "https://ebird.org/hotspot/" + hotspotId)!)
    }
}
