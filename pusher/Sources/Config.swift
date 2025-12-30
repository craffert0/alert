// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

struct Config: Codable {
    var apnTeamIdentifier: String
    var apnKeyIdentifier: String
    var apnPrivateKeyArray: [String]
}

extension Config {
    var apnPrivateKey: String {
        apnPrivateKeyArray.joined(separator: "\n")
    }
}

extension Config {
    init(fileName: String) throws {
        self = try JSONDecoder()
            .decode(Config.self,
                    from: FileManager.default.contents(atPath: fileName)!)
    }
}
