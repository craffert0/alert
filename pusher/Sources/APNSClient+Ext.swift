// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import APNS
import Foundation

extension APNSClient<JSONDecoder, JSONEncoder> {
    convenience init(privateKey: String) throws {
        try self.init(
            configuration: .init(
                authenticationMethod: .jwt(
                    privateKey: .init(pemRepresentation: privateKey),
                    keyIdentifier: "NK5PK5BWL5",
                    teamIdentifier: "65BH4M439S"
                ),
                environment: .development
            ),
            eventLoopGroupProvider: .createNew,
            responseDecoder: JSONDecoder(),
            requestEncoder: JSONEncoder()
        )
    }
}
