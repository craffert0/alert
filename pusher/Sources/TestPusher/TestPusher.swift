// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import APNS
import ArgumentParser

@main
struct TestPusher: AsyncParsableCommand {
    @Argument(transform: Config.init(fileName:)) var config: Config
    @Argument var device_token: String

    func run() async throws {
        let client = try APNSClient(teamIdentifier: config.apnTeamIdentifier,
                                    keyIdentifier: config.apnKeyIdentifier,
                                    privateKey: config.apnPrivateKey)

        try await client.sendAlertNotification(
            .init(birds: ["Black & White Warbler", "Turkey Vulture"],
                  payload: Payload()),
            deviceToken: device_token
        )

        // Shutdown the client when done
        try await client.shutdown()
    }
}
