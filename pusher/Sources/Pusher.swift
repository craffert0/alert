// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import APNS
import ArgumentParser
import Foundation
import System

struct Payload: Codable {}

@main
struct Pusher: AsyncParsableCommand {
    @Argument(transform: FilePath.init(stringLiteral:))
    var key_file: FilePath
    @Argument var device_token: String

    private var key_text: String {
        String(data: FileManager.default.contents(atPath: key_file.string)!,
               encoding: .utf8)!
    }

    func run() async throws {
        let client = try APNSClient(privateKey: key_text)

        try await client.sendAlertNotification(
            .init(
                alert: .init(
                    title: .raw("New Bird"),
                    subtitle: .raw("Subtitle"),
                    body: .raw("Black & White Warbler"),
                    launchImage: nil
                ),
                expiration: .immediately,
                priority: .immediately,
                topic: "net.rafferty.colin.eBirdAlert",
                payload: Payload()
            ),
            deviceToken: device_token
        )

        // Shutdown the client when done
        try await client.shutdown()
    }
}
