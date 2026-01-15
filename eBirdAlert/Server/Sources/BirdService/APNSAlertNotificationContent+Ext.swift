// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import APNSCore

extension APNSAlertNotificationContent {
    init(newBirds: Set<String>) {
        self.init(
            title: .raw(newBirds.count == 1 ? "New Rarity" : "New Rarities"),
            body: .raw(newBirds.joined(separator: ", ")),
            launchImage: nil
        )
    }
}
