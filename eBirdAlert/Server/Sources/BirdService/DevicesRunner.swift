// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Logging
import Schema

struct DevicesRunner: Sendable {
    let provider: ModelProvider
    let birdService: eBirdService
    let notificationService: NotificationService
    let logger: Logger

    func run() async throws {
        logger.info("run")
        for device in try await provider.getDevices() {
            try await device.update(provider: provider,
                                    birdService: birdService,
                                    notificationService: notificationService,
                                    logger: logger)
        }
    }
}
