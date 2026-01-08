// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
@testable import BirdService
import Cuckoo
import Foundation
import Testing

@Suite struct DevicesRunnerTest {
    let provider: MockDevicesProvider
    let birdService: MockBirdService
    let notificationService: MockNotificationService
    let runner: DevicesRunner

    let kRange = Components.Schemas.Range.RegionCode("NY")

    private func device(deviceId: String? = nil,
                        deviceResult: [String],
                        mostRecentResult: [String]) -> Device
    {
        let device = Device()
        if let deviceId {
            device.deviceId = deviceId
        }
        device.range = kRange
        device.deviceResult = deviceResult
        device.mostRecentResult = mostRecentResult
        return device
    }

    init() {
        provider = MockDevicesProvider()
        birdService = MockBirdService()
        notificationService = MockNotificationService()

        runner = DevicesRunner(provider: provider,
                               birdService: birdService,
                               notificationService: notificationService)
    }

    @Test func noDevices() async throws {
        stub(provider) { stub in
            when(stub.getAll()).thenReturn([])
        }
        try await runner.run()
    }

    @Test func sameBirds() async throws {
        let birds = ["cangoo", "blwwhi"]
        let device = device(deviceResult: birds, mostRecentResult: birds)
        stub(provider) { stub in
            when(stub.getAll()).thenReturn([device])
        }
        stub(birdService) { stub in
            when(stub.getBirds(in: equal(to: kRange))).thenReturn(birds)
        }
        try await runner.run()
    }

    @Test func newBirds() async throws {
        let deviceResult = ["cangoo", "blwwhi"]
        let latestResult = ["blwwhi", "cuckoo", "horlar"]
        let expected = Set(["cuckoo", "horlar"])
        let device = device(deviceId: "abc",
                            deviceResult: deviceResult,
                            mostRecentResult: deviceResult)
        var actualMostRecentResult: [String] = []
        stub(provider) { stub in
            when(stub.getAll())
                .thenReturn([device])
            when(stub.update(device: equal(to: device)))
                .then { device in
                    actualMostRecentResult = device.mostRecentResult
                }
        }
        stub(birdService) { stub in
            when(stub.getBirds(in: equal(to: kRange)))
                .thenReturn(latestResult)
        }
        stub(notificationService) { stub in
            when(stub.notify(device.deviceId, newBirds: equal(to: expected)))
                .then { _ in }
        }
        try await runner.run()
        #expect(Set(actualMostRecentResult) == Set(latestResult))
    }

    @Test func allDifferentBirds() async throws {
        let deviceResult = ["cangoo", "blwwhi"]
        let mostRecentResult = ["cangoo", "blwwhi", "cuckoo"]
        let latestResult = ["blwwhi", "cuckoo", "horlar"]
        let expected = Set(["horlar"])
        let device = device(deviceId: "abc",
                            deviceResult: deviceResult,
                            mostRecentResult: mostRecentResult)
        var actualMostRecentResult: [String] = []
        stub(provider) { stub in
            when(stub.getAll())
                .thenReturn([device])
            when(stub.update(device: equal(to: device)))
                .then { device in
                    actualMostRecentResult = device.mostRecentResult
                }
        }
        stub(birdService) { stub in
            when(stub.getBirds(in: equal(to: kRange)))
                .thenReturn(latestResult)
        }
        stub(notificationService) { stub in
            when(stub.notify(device.deviceId, newBirds: equal(to: expected)))
                .then { _ in }
        }
        try await runner.run()
        #expect(Set(actualMostRecentResult) == Set(latestResult))
    }
}
