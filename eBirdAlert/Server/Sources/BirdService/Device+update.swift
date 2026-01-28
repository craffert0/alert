// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Logging
import Schema

extension Device {
    func update(provider: ModelProvider,
                birdService: eBirdService,
                notificationService: NotificationService,
                logger: Logger) async throws
    {
        guard let range else {
            logger.info("skipping \(name)")
            return
        }
        let nowObs =
            try await birdService.getNotable(in: range.model,
                                             back: daysBack)
        let nowSpecies = Set(nowObs.map(\.speciesCode))
        let pushSpecies = nowSpecies.subtracting(deviceSpecies)
        if pushSpecies != Set(mostRecentPushSpecies) {
            logger.info("new birds \(name): \(pushSpecies)")
            let birdNames = pushSpecies.map { code in
                nowObs.first(where: { $0.speciesCode == code })!.comName
            }
            try await notificationService.notify(deviceId,
                                                 deviceType: deviceType,
                                                 newBirds: Set(birdNames),
                                                 badgeCount: birdNames.count)
            mostRecentPushSpecies = Array(pushSpecies)
            try await provider.update(device: self)
        } else {
            logger.info("same old \(name)")
        }
    }
}
