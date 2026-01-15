// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import APNSCore

extension APNSAlertNotification<Payload> {
    init(birds: [String], payload: Payload) {
        self.init(
            alert: .init(
                title: .raw(birds.count == 1 ? "New Rarity" : "New Rarities"),
                body: .raw(birds.joined(separator: ", ")),
                launchImage: nil
            ),
            expiration: .immediately,
            priority: .immediately,
            topic: "net.rafferty.colin.eBirdAlert",
            payload: payload
        )
    }
}
