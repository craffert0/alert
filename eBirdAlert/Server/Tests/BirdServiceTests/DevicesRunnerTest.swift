// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
@testable import BirdService
import Cuckoo
import Foundation
import Network
import Schema
import Testing

@Suite struct DevicesRunnerTest {
    let provider: MockModelProvider
    let birdService: MockeBirdService
    let notificationService: MockNotificationService
    let runner: DevicesRunner

    let kRange = RangeType.region(.kings).api
    let kDaysBack = 3

    private func device(deviceId: String? = nil,
                        deviceResult: [String],
                        mostRecentResult: [String]) -> Device
    {
        let device = Device()
        if let deviceId {
            device.deviceId = deviceId
        }
        device.range = kRange
        device.daysBack = kDaysBack
        device.deviceResult = deviceResult
        device.mostRecentResult = mostRecentResult
        return device
    }

    init() {
        provider = MockModelProvider()
        birdService = MockeBirdService()
        notificationService = MockNotificationService()

        runner = DevicesRunner(provider: provider,
                               birdService: birdService,
                               notificationService: notificationService)
    }

    @Test func noDevices() async throws {
        stub(provider) { stub in
            when(stub.getDevices()).thenReturn([])
        }
        try await runner.run()
    }

    @Test func sameBirds() async throws {
        let birds = ["cangoo", "blwwhi"]
        let device = device(deviceResult: birds, mostRecentResult: birds)
        stub(provider) { stub in
            when(stub.getDevices()).thenReturn([device])
        }
        stub(birdService) { stub in
            when(stub.getNotable(in: equal(to: kRange.model), back: kDaysBack))
                .thenReturn(birds.fakes)
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
            when(stub.getDevices())
                .thenReturn([device])
            when(stub.update(device: equal(to: device)))
                .then { device in
                    actualMostRecentResult = device.mostRecentResult
                }
        }
        stub(birdService) { stub in
            when(stub.getNotable(in: equal(to: kRange.model), back: kDaysBack))
                .thenReturn(latestResult.fakes)
        }
        stub(notificationService) { stub in
            when(stub.notify(device.deviceId,
                             newBirds: equal(to: expected),
                             badgeCount: 2))
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
            when(stub.getDevices())
                .thenReturn([device])
            when(stub.update(device: equal(to: device)))
                .then { device in
                    actualMostRecentResult = device.mostRecentResult
                }
        }
        stub(birdService) { stub in
            when(stub.getNotable(in: equal(to: kRange.model), back: kDaysBack))
                .thenReturn(latestResult.fakes)
        }
        stub(notificationService) { stub in
            when(stub.notify(device.deviceId,
                             newBirds: equal(to: expected),
                             badgeCount: 2))
                .then { _ in }
        }
        try await runner.run()
        #expect(Set(actualMostRecentResult) == Set(latestResult))
    }

    @Test func iterativeBadgeCount() async throws {
        let base = ["cangoo", "blwwhi"]
        let device = device(deviceId: "abc",
                            deviceResult: base,
                            mostRecentResult: base)
        stub(provider) { stub in
            when(stub.getDevices())
                .thenReturn([device])
            when(stub.update(device: equal(to: device)))
                .then { _ in }
        }
        let run: ([String], [String]?, Int?) async throws -> Void = {
            result, expected, badgeCount in
            stub(birdService) { stub in
                when(stub.getNotable(in: equal(to: kRange.model), back: kDaysBack))
                    .thenReturn(result.fakes)
            }
            if let expected, let badgeCount {
                stub(notificationService) { stub in
                    when(stub.notify(device.deviceId,
                                     newBirds: equal(to: Set(expected)),
                                     badgeCount: badgeCount))
                        .then { _ in }
                }
            }
            try await runner.run()
        }
        try await run(["cangoo", "blwwhi", "horlar", "cuckoo"],
                      ["horlar", "cuckoo"],
                      2)
        try await run(["cangoo", "blwwhi", "horlar", "cuckoo"], nil, nil)
        try await run(["blwwhi", "horlar", "cuckoo", "chicken"],
                      ["chicken"],
                      3)
        try await run(["blwwhi", "horlar", "cuckoo"], nil, nil)
    }
}
