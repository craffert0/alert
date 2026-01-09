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
        let nowBirds =
            try await birdService.getBirds(in: range,
                                           back: device.daysBack)
        let oldBirds = Set(device.mostRecentResult)
        let newBirds = nowBirds.subtracting(oldBirds)
        if !newBirds.isEmpty {
            try await notificationService.notify(device.deviceId,
                                                 newBirds: newBirds)
        }
        if nowBirds != oldBirds {
            device.mostRecentResult = Array(nowBirds)
            try await provider.update(device: device)
        }
    }
}
