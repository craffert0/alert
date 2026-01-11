// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import FluentSQLiteDriver
import Foundation
import Vapor

struct Config: Codable {
    let apikey: String
    let apnTeamIdentifier: String
    let apnKeyIdentifier: String
    let apnPrivateKeyArray: [String]
    let servicePort: Int
    let databaseConfig: String
}

extension Config {
    var apnPrivateKey: String {
        apnPrivateKeyArray.joined(separator: "\n")
    }
}

extension Config {
    var address: BindAddress {
        .hostname("0.0.0.0", port: servicePort)
    }

    var database: DatabaseConfigurationFactory {
        if databaseConfig == "memory" {
            .sqlite(.memory)
        } else {
            .sqlite(.file(databaseConfig))
        }
    }
}

extension Config {
    static let global =
        try! JSONDecoder()
            .decode(Config.self,
                    from: FileManager.default.contents(
                        atPath: NSHomeDirectory() + "/.ebirdrc")!)
}
