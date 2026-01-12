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
        let oldBirds = Set(device.mostRecentResult)
        let newBirds = nowBirds.subtracting(oldBirds)
        if !newBirds.isEmpty {
            logger.info("new birds \(device.id?.uuidString ?? "<>"): \(newBirds)")
            let birdNames = newBirds.map { code in
                nowInfos.first(where: { $0.speciesCode == code })!.comName
            }
            let deviceBirds = Set(device.deviceResult)
            let badgeCount = nowBirds.subtracting(deviceBirds).count
            try await notificationService.notify(device.deviceId,
                                                 newBirds: Set(birdNames),
                                                 badgeCount: badgeCount)
        } else {
            logger.info("same old \(device.id?.uuidString ?? "<>")")
        }
        if nowBirds != oldBirds {
            device.mostRecentResult = Array(nowBirds)
            try await provider.update(device: device)
        }
    }
}
