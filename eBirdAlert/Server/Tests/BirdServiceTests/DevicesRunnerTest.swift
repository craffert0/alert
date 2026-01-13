// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
@testable import BirdService
import Cuckoo
import Foundation
import Logging
import Network
import Schema
import Testing

enum TestError: Error {
    case unexpectedNotification
}

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

    private func setup(_ deviceResult: [String],
                       mostRecentResult: [String]? = nil)
    {
        let device = device(deviceId: "deviceId",
                            deviceResult: deviceResult,
                            mostRecentResult: mostRecentResult ?? deviceResult)

        stub(provider) { stub in
            when(stub.getDevices())
                .thenReturn([device])
            when(stub.update(device: equal(to: device)))
                .then { _ in }
        }
    }

    private func run(_ result: [String],
                     _ expected: [String]? = nil,
                     _ badgeCount: Int? = nil) async throws
    {
        stub(birdService) { stub in
            when(stub.getNotable(in: equal(to: kRange.model), back: kDaysBack))
                .thenReturn(result.fakes)
        }
        if let expected, let badgeCount {
            stub(notificationService) { stub in
                when(stub.notify("deviceId",
                                 newBirds: equal(to: Set(expected)),
                                 badgeCount: badgeCount))
                    .then { _ in }
            }
        } else {
            stub(notificationService) { stub in
                when(stub.notify("deviceId",
                                 newBirds: any(),
                                 badgeCount: anyInt()))
                    .thenThrow(TestError.unexpectedNotification)
            }
        }

        try await runner.run()
    }

    init() {
        provider = MockModelProvider()
        birdService = MockeBirdService()
        notificationService = MockNotificationService()

        runner = DevicesRunner(provider: provider,
                               birdService: birdService,
                               notificationService: notificationService,
                               logger: Logger(label: "testy"))
    }

    @Test func noDevices() async throws {
        stub(provider) { stub in
            when(stub.getDevices()).thenReturn([])
        }
        try await runner.run()
    }

    @Test func sameBirds() async throws {
        let birds = ["cangoo", "blwwhi"]
        setup(birds)
        try await run(birds)
    }

    @Test func newBirds() async throws {
        let deviceResult = ["cangoo", "blwwhi"]
        let latestResult = ["blwwhi", "cuckoo", "horlar"]
        let expected = ["f-cuckoo", "f-horlar"]
        setup(deviceResult)
        try await run(latestResult, expected, 2)
    }

    @Test func allDifferentBirds() async throws {
        let deviceResult = ["cangoo", "blwwhi"]
        let mostRecentResult = ["cangoo", "blwwhi", "cuckoo"]
        let latestResult = ["blwwhi", "cuckoo", "horlar"]
        let expected = ["f-horlar"]
        setup(deviceResult, mostRecentResult: mostRecentResult)
        try await run(latestResult, expected, 2)
    }

    @Test func iterativeBadgeCount() async throws {
        let base = ["cangoo", "blwwhi"]
        setup(base)
        try await run(["cangoo", "blwwhi", "horlar", "cuckoo"],
                      ["f-horlar", "f-cuckoo"],
                      2)
        try await run(["cangoo", "blwwhi", "horlar", "cuckoo"], nil, nil)
        try await run(["blwwhi", "horlar", "cuckoo", "chicken"],
                      ["f-chicken"],
                      3)
        try await run(["blwwhi", "horlar", "cuckoo"], nil, nil)
    }
}
