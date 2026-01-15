// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
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
            try await run(device: device)
        }
    }

    private func run(device: Device) async throws {
        guard let range = device.range else {
            logger.info("skipping \(device.id?.uuidString ?? "<>")")
            return
        }
        let nowInfos =
            try await birdService.getNotable(in: range.model,
                                             back: device.daysBack)
        let nowBirds = Set(nowInfos.map(\.speciesCode))
        let pushBirds = nowBirds.subtracting(device.deviceResult)
        if pushBirds != Set(device.mostRecentPush) {
            logger.info("new birds \(device.id?.uuidString ?? "<>"): \(pushBirds)")
            let birdNames = pushBirds.map { code in
                nowInfos.first(where: { $0.speciesCode == code })!.comName
            }
            try await notificationService.notify(device.deviceId,
                                                 newBirds: Set(birdNames),
                                                 badgeCount: pushBirds.count)
            device.mostRecentPush = Array(pushBirds)
            try await provider.update(device: device)
        } else {
            logger.info("same old \(device.id?.uuidString ?? "<>")")
        }
    }
}
