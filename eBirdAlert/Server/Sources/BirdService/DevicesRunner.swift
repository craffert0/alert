// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema

struct DevicesRunner: Sendable {
    let provider: ModelProvider
    let birdService: eBirdService
    let notificationService: NotificationService

    func run() async throws {
        for device in try await provider.getDevices() {
            try await run(device: device)
        }
    }

    private func run(device: Device) async throws {
        guard let range = device.range else { return }
        let nowInfos =
            try await birdService.getNotable(in: range.model,
                                             back: device.daysBack)
        let nowBirds = Set(nowInfos.map(\.speciesCode))
        let oldBirds = Set(device.mostRecentResult)
        let newBirds = nowBirds.subtracting(oldBirds)
        if !newBirds.isEmpty {
            let birdNames = newBirds.map { code in
                nowInfos.first(where: { $0.speciesCode == code })!.comName
            }
            let deviceBirds = Set(device.deviceResult)
            let badgeCount = nowBirds.subtracting(deviceBirds).count
            try await notificationService.notify(device.deviceId,
                                                 newBirds: Set(birdNames),
                                                 badgeCount: badgeCount)
        }
        if nowBirds != oldBirds {
            device.mostRecentResult = Array(nowBirds)
            try await provider.update(device: device)
        }
    }
}
